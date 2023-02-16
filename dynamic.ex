defmodule Dynamic do

  def search(seq) do elem(search(seq, Map.new()), 0) end

  def check(seq, mem) do
    case Map.get(mem, seq) do
      nil ->
        {cost, mem} = search(seq, mem)
        {cost, Map.put(mem, seq, cost)}
      cost ->
        {cost, mem}
    end
  end

  def search([], mem) do {0, mem} end
  def search([_], mem) do {0, mem} end
  def search(seq, mem) do
    Enum.reduce(split(seq), {:big, mem}, fn({left, right, length}, {acc, mem}) ->
      {costLeft, mem} = check(left, mem)
      {costRight, mem} = check(right, mem)
      cost = costLeft + costRight + length
      {min(acc, cost), mem}
    end)
  end

  def split([x|seq]) do split(seq, x, [x], [], []) end

  def split([], length, left, right, acc) do [{Enum.reverse(left), Enum.reverse(right), length}|acc] end
  def split([x], length, [], right, acc) do [{[x], Enum.reverse(right), length+x}|acc] end
  def split([x], length, left, [], acc) do [{Enum.reverse(left), [x], length+x}|acc] end
  def split([x|seq], length, left, right, acc) do
    split(seq, length+x, [x|left], right, split(seq, length+x, left, [x|right], acc))
  end

end
