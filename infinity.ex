defmodule Infinity do
  def infinity() do
    fn() -> infinity(0) end
  end
  def infinity(n) do
    [n|fn() -> infinity(n+1) end]
  end
end
