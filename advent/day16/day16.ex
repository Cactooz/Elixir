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

  def valveCheck(_, _, _, 0, sum) do sum end
  def valveCheck(_, _, [], _, sum) do sum end
  def valveCheck(map, turnedOn, [pipe|pipes], timeLeft, sum) do
    head = valveCheck(map, turnedOn, pipe, timeLeft-1, sum)
    tail = valveCheck(map, turnedOn, pipes, timeLeft, sum)
    case head > tail do
      true -> head
      false -> tail
    end
  end

  def valveCheck(map, turnedOn, valve, timeLeft, sum) do
    case Map.fetch(turnedOn, valve) do
      {:ok, _} ->
        {:ok, {_, connections}} = Map.fetch(map, valve)
        valveCheck(map, turnedOn, connections, timeLeft, sum)
      :error ->
        {:ok, {flow, connections}} = Map.fetch(map, valve)
        skip = valveCheck(map, turnedOn, connections, timeLeft, sum)
        turnOn = valveCheck(map, Map.put(turnedOn, valve, 0), connections, timeLeft-1, sum+(flow*(timeLeft-1)))
        case turnOn > skip do
          true -> turnOn
          false -> skip
        end
      end
  end
end
