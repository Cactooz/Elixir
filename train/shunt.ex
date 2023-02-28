defmodule Shunt do
  def find([], []) do [] end
  def find(start, [wagon|final]) do
    {startWagons, endWagons} = Train.split(start, wagon)
    startLength = length(startWagons)
    endLength = length(endWagons)
    [{:one, endLength+1},
     {:two, startLength},
     {:one, -(endLength+1)},
     {:two, -startLength} |
     find(Train.append(startWagons, endWagons), final)]
  end
end
