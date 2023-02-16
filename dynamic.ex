defmodule Dynamic do
  def search([]) do 0 end
  def search([_]) do 0 end
  def search(seq) do
    Enum.reduce(split(seq), :big, fn({left, right, length}, acc) ->
      cost = search(left) + search(right) + length
      min(acc, cost)
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
