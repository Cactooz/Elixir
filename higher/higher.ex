defmodule Higher do
  def mul([], _) do [] end
  def mul([head|tail], n) do
    [head*n|mul(tail, n)]
  end

  def add([], _) do [] end
  def add([head|tail], n) do
    [head+n|add(tail, n)]
  end

  def sum([]) do 0 end
  def sum([head|tail]) do
    head + sum(tail)
  end

  def odd([]) do [] end
  def odd([head|tail]) do
    if(rem(head,2) == 1) do
      [head|odd(tail)]
    else
      odd(tail)
    end
  end

  def apply_to_all([], _) do [] end
  def apply_to_all([head|tail], f) do
    [f.(head)|apply_to_all(tail, f)]
  end
end
