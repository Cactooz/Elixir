defmodule Row do
  def new() do MapSet.new() end

  def block(row, from, to) do
    Enum.reduce(from..to, row, fn(i, r) -> MapSet.put(r, i) end)
  end

  def blocked(row) do MapSet.size(row) end
end
