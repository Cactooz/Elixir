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

  def split([x|seq]) do split(seq, x, [x], []) end

  def split([], length, left, right) do [{left, right, length}] end
  def split([x], length, [], right) do [{[x], right, length+x}] end
  def split([x], length, left, []) do [{left, [x], length+x}] end
  def split([x|seq], length, left, right) do
    split(seq, length+x, [x|left], right) ++ split(seq, length+x, left, [x|right])
  end

end
