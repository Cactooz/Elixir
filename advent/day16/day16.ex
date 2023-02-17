defmodule Day16 do
  def task() do
    start = :AA
    #rows = File.stream!("day16.csv")
    #rows = sample()
    rows = simple()
    parse(rows)
  end

  ## turning rows
  ##  "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE"
  ## into tuples
  ##  {:DD, {20, [:CC, :AA, :EE]}
  def parse(input) do
    Enum.map(input, fn(row) ->
      [valve, rate, valves] = String.split(String.trim(row), ["=", ";"])
      [_Valve, valve | _has_flow_rate ] = String.split(valve, [" "])
      valve = String.to_atom(valve)
      {rate,_} = Integer.parse(rate)
      [_, _tunnels,_lead,_to,_valves| valves] = String.split(valves, [" "])
      valves = Enum.map(valves, fn(valve) -> String.to_atom(String.trim(valve,",")) end)
      {valve, {rate, valves}}
    end)
  end

  def sample() do
    ["Valve AA has flow rate=0; tunnels lead to valves DD, II, BB",
     "Valve BB has flow rate=13; tunnels lead to valves CC, AA",
     "Valve CC has flow rate=2; tunnels lead to valves DD, BB",
     "Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE",
     "Valve EE has flow rate=3; tunnels lead to valves FF, DD",
     "Valve FF has flow rate=0; tunnels lead to valves EE, GG",
     "Valve GG has flow rate=0; tunnels lead to valves FF, HH",
     "Valve HH has flow rate=22; tunnel leads to valve GG",
     "Valve II has flow rate=0; tunnels lead to valves AA, JJ",
     "Valve JJ has flow rate=21; tunnel leads to valve II"]
  end

  def simple() do
    ["Valve AA has flow rate=0; tunnels lead to valves BB, CC, EE, FF",
     "Valve BB has flow rate=30; tunnels lead to valves AA, CC, DD",
     "Valve CC has flow rate=25; tunnels lead to valves AA, BB, EE",
     "Valve DD has flow rate=35; tunnels lead to valves BB",
     "Valve EE has flow rate=10; tunnels lead to valves AA, CC, FF",
     "Valve FF has flow rate=50; tunnels lead to valves AA, EE"]
  end

  def addValves([]) do [] end
  def addValves([valve|valves]) do
    {valve, {flow, _}} = valve
    if(flow > 0) do
      [valve|addValves(valves)]
    else
      addValves(valves)
    end
  end

  def memoryCheck(valve, flow, open, [], timeLeft, _map, memory) do
    total = flow * timeLeft
    {total, Map.put(memory, {valve, open, timeLeft}, total)}
  end
  def memoryCheck(valve, flow, open, closed, timeLeft, map, memory) do
    case Map.get(memory, {valve, open, timeLeft}) do
      nil ->
        #Does not exist in the memory, search for it
        {maxFlow, memory} = valveCheck(valve, flow, open, closed, timeLeft, map, memory)
        {maxFlow, Map.put(memory, {valve, open, timeLeft}, maxFlow)}
      maxFlow ->
        #Return the calcuated memory
        {maxFlow, memory}
    end
  end

  #If the time is out
  def valveCheck(_valve, _flow, _open, _closed, 0, _map, memory) do
    {0, memory}
  end
  def valveCheck(valve, totalFlow, open, closed, timeLeft, map, memory) do
    {:ok, {flow, connections}} = Map.fetch(map, valve)

    {valveFlow, memory} = case Enum.member?(closed, valve) do
      true ->
        #Open the valve
        newClosed = List.delete(closed, valve)
        {openFlow, memory} = memoryCheck(valve, totalFlow+flow, [valve|open], newClosed, timeLeft-1, map, memory)
        {openFlow + totalFlow, memory}
      false ->
        {totalFlow*timeLeft, memory}
    end

    #Check if the connections are better
    Enum.reduce(connections, {valveFlow, memory}, fn(connectingValve, {valveFlow, memory}) ->
      {connectionFlow, memory} = memoryCheck(connectingValve, totalFlow, open, closed, timeLeft-1, map, memory)
      connectionFlow = connectionFlow + totalFlow
      case valveFlow > connectionFlow do
        true -> {valveFlow, memory}
        false -> {connectionFlow, memory}
      end
    end)
  end
end
