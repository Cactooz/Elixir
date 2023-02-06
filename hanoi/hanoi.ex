defmodule Hanoi do
  def hanoi(0, _, _, _) do [] end
  def hanoi(n, from, aux, to) do
    hanoi(n-1, from, to, aux) ++
    [{:move, from, to}] ++
    hanoi(n-1, aux, from, to)
  end

  def count([], amount) do amount end
  def count([_|list], amount) do
    count(list, amount+1)
  end
end
