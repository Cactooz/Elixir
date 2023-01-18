defmodule Derivative do
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal() | {:add, expr(), expr()} | {:mul, expr(), expr()}

  def test() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
    derive(e, :x)
  end

  def derive({:num, _}, _) do {:num, 0} end

  def derive({:var, v}, v) do {:num, 1} end

  def derive({:var, _}, _) do {:num, 0} end

  def derive({:add, e1, e2}, v) do
    {:add, derive(e1, v), derive(e2, v)}
  end

  def derive({:mul, e1, e2}, v) do
    {:add, {:mul, derive(e1, v), e2}, {:mul, e1, derive(e2, v)}}
  end
end
