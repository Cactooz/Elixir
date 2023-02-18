defmodule Row do
  def new() do [] end

  def block([], from, to) do [{from, to}] end
  def block([{f, t}|rest], from, to) when from > (t+1) do
    [{f, t}|block(rest, from, to)]
  end
  def block([{f, _t}|_]=rest, from, to) when to < (f-1) do
    [{from,to}|rest]
  end
  def block([{f, t}|rest], from, to) do
    block(rest, min(f, from), max(t, to))
  end

  def blocked(row) do
    row
  end
end
