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
    ["Valve AA has flow rate=0; tunnels lead to valves BB, CC",
     "Valve BB has flow rate=30; tunnels lead to valves AA, CC, DD",
     "Valve CC has flow rate=25; tunnels lead to valves AA, BB",
     "Valve DD has flow rate=35; tunnels lead to valves BB"]
  end

  def memoryCheck(valve, flow, open, closed, timeLeft, map, memory) do
    case Map.get(memory, {valve, open, closed, timeLeft}) do
      nil ->
        {flow, memory} = valveCheck(valve, flow, open, closed, timeLeft, map, memory)
        {flow, Map.put(memory, {valve, open, closed, timeLeft}, flow)}
      flow ->
        {flow, memory}
    end
  end

  #If there are no more valves to check in the list
  def valveCheck([], flow, _open, _closed, _timeLeft, _map, memory) do
    {flow, memory}
  end
  #If all the valves are open
  def valveCheck(_valve, flow, _open, [], _timeLeft, _map, memory) do
    {flow, memory}
  end
  #If the time is out
  def valveCheck(_valve, flow, _open, _closed, 0, _map, memory) do
    {flow, memory}
  end
  #Check the connecting paths to other valves which has the best flow
  def valveCheck([valve|valves], flow, open, closed, timeLeft, map, memory) do
    #Go to the first connecting pipe
    {firstFlow, memory} = memoryCheck(valve, flow, open, closed, timeLeft-1, map, memory)
    #Go to the other connecting pipes
    {restFlow, memory} = valveCheck(valves, flow, open, closed, timeLeft, map, memory)
    #Get the path with the best flow
    {max(firstFlow, restFlow), memory}
  end
  #Check a single valve
  def valveCheck(valve, flow, open, closed, timeLeft, map, memory) do
    case Map.fetch(open, valve) do
      #If the valve is already opened
      {:ok, _} ->
        {:ok, {_, connections}} = Map.fetch(map, valve)
        #Check all connecting valves
        valveCheck(connections, flow, open, closed, timeLeft, map, memory)
      :error ->
        {:ok, {valveFlow, connections}} = Map.fetch(map, valve)
        #Skip the current valve and check the connecting valves
        skip = valveCheck(connections, flow, open, closed, timeLeft, map, memory)
        #Turn on the current valve
        turnOn = memoryCheck(valve, flow+valveFlow*(timeLeft-1), Map.put(open, valve, 0), Map.delete(closed, valve), timeLeft-1, map, memory)
        #Check which of the two was the best
        max(skip, turnOn)
    end
  end
end
