defmodule Derivative do
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal() |
  {:add, expr(), expr()} |
  {:sub, expr(), expr()} |
  {:mul, expr(), expr()} |
  {:div, expr(), expr()} |
  {:exp, expr(), {:num, literal()}} |
  {:ln, expr()}

  def test() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
    d = derive(e, :x)
    IO.write("Derivative: #{print(d)} for expression #{print(e)}")
  end

  def exp() do
    e = {:exp, {:var, :x}, {:num, 2}}
    d = derive(e, :x)
    IO.write("Derivative: #{print(d)} for expression #{print(e)}")
  end

  def ln() do
    e = {:ln, {:var, :x}}
    d = derive(e, :x)
    IO.write("Derivative: #{print(d)} for expression #{print(e)}")
  end

  def div() do
    e = {:div, {:add, {:num, 1}, {:var, :x}}, {:sub, {:var, :x}, {:num, 2}}}
    d = derive(e, :x)
    IO.write("Derivative: #{print(d)} for expression #{print(e)}")
  end

  def derive({:num, _}, _) do {:num, 0} end

  def derive({:var, v}, v) do {:num, 1} end

  def derive({:var, _}, _) do {:num, 0} end

  def derive({:add, e1, e2}, v) do
    {:add, derive(e1, v), derive(e2, v)}
  end

  def derive({:sub, e1, e2}, v) do
    {:sub, derive(e1, v), derive(e2, v)}
  end

  def derive({:mul, e1, e2}, v) do
    {:add, {:mul, derive(e1, v), e2}, {:mul, e1, derive(e2, v)}}
  end

  def derive({:div, top, div}, v) do
    {:div,
    {:sub,
      {:mul, derive(top, v), div},
      {:mul, top, derive(div, v)}},
    {:exp, div, {:num, 2}}}
  end

  def derive({:exp, base, {:num, exp}}, v) do
    {:mul, {:mul, {:num, exp}, {:exp, base, {:num, exp - 1}}}, derive(base, v)}
  end

  def derive({:ln, e}, v) do
    {:div, {:mul, derive(e, v), {:num, 1}}, e}
  end

  def print({:num, n}) do "#{n}" end
  def print({:var, v}) do "#{v}" end
  def print({:add, e1, e2}) do "(#{print(e1)} + #{print(e2)})" end
  def print({:sub, e1, e2}) do "(#{print(e1)} - #{print(e2)})" end
  def print({:mul, e1, e2}) do "#{print(e1)} * #{print(e2)}" end
  def print({:div, top, div}) do "(#{print(top)}) / (#{print(div)})" end
  def print({:exp, base, exp}) do "(#{print(base)}) ^ (#{print(exp)})" end
  def print({:ln, e}) do "ln(#{print(e)})" end
end
