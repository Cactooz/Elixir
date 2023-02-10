defmodule Higher do
  def mul([], _) do [] end
  def mul([head|tail], n) do
    [head*n|mul(tail, n)]
  end

  def add([], _) do [] end
  def add([head|tail], n) do
    [head+n|add(tail, n)]
  end

  def apply_to_all([], _) do [] end
  def apply_to_all([head|tail], f) do
    [f.(head)|apply_to_all(tail, f)]
  end
end
