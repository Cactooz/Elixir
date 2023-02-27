defmodule Train do
  def take(_, 0) do [] end
  def take([], _n) do [] end
  def take([wagon|train], n) do
    [wagon|take(train, n-1)]
  end

  def drop(wagons, 0) do wagons end
  def drop([], _n) do [] end
  def drop([_|wagons], n) do
    drop(wagons, n-1)
  end

  def append([], []) do [] end
  def append(wagons, []) do wagons end
  def append([], wagons) do wagons end
  def append([wagon|train], wagons2) do
    [wagon|append(train, wagons2)]
  end

  def member([], _wagon) do false end
  def member([wagon|_train], wagon) do true end
  def member([_|train], wagon) do
    member(train, wagon)
  end

  def position(train, wagon) do
    position(train, wagon, 1)
  end

  def position([], _wagon, _pos) do nil end
  def position([wagon|_], wagon, pos) do pos end
  def position([_|train], wagon, pos) do
    position(train, wagon, pos+1)
  end

  def split([], _wagon) do {[], []} end
  def split(train, wagon) do
    pos = position(train, wagon)
    case pos == nil do
      :true -> {train, []}
      :false -> {take(train, pos-1), drop(train, pos)}
    end
  end

  def main([], n) do {n, [], []} end
  def main([wagon|train], moves) do
    case main(train, moves) do
      {0, drop, take} -> {0, [wagon|drop], take}
      {n, drop, take} -> {n-1, drop, [wagon|take]}
    end
  end
end
