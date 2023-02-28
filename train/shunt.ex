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

  def few([], []) do [] end
  def few([wagon|start], [wagon|final]) do few(start, final) end
  def few(start, [wagon|final]) do
    {startWagons, endWagons} = Train.split(start, wagon)
    startLength = length(startWagons)
    endLength = length(endWagons)
    [{:one, endLength+1},
     {:two, startLength},
     {:one, -(endLength+1)},
     {:two, -startLength} |
     few(Train.append(startWagons, endWagons), final)]
  end

  def rules([]) do [] end
  def rules([{_, 0}|moves]) do rules(moves) end
  def rules([_move1, _move2|moves]) do rules(moves) end
  def rules([{track, move1}, {track, move2}|moves]) do
    rules([{track, move1+move2}|moves])
  end

  def compress(moves) do
    compressed = rules(moves)
    if rules(moves) == moves do
      moves
    else
      compress(compressed)
    end
  end
end
