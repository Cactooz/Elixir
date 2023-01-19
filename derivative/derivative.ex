defmodule Derivative do
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal() |
  {:add, expr(), expr()} |
  {:sub, expr(), expr()} |
  {:mul, expr(), expr()} |
  {:div, expr(), expr()} |
  {:exp, expr(), {:num, literal()}} |
  {:ln, expr()} |
  {:sqrt, expr()} |
  {:sin, expr()} |
  {:cos, expr()}

  def test() do
    e = {:add, {:mul, {:num, 2}, {:var, :x}}, {:num, 4}}
    d = derive(e, :x)
    s = simplify(d)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplification: #{print(s)}\n")
  end

  def exp() do
    e = {:exp, {:var, :x}, {:num, 2}}
    d = derive(e, :x)
    s = simplify(d)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplification: #{print(s)}\n")
  end

  def ln() do
    e = {:ln, {:var, :x}}
    d = derive(e, :x)
    s = simplify(d)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplification: #{print(s)}\n")
  end

  def div() do
    e = {:div, {:add, {:num, 1}, {:var, :x}}, {:sub, {:var, :x}, {:num, 2}}}
    d = derive(e, :x)
    s = simplify(d)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplification: #{print(s)}\n")
  end

  def sqrt() do
    e = {:sqrt, {:exp, {:var, :x}, {:num, 2}}}
    d = derive(e, :x)
    s = simplify(d)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplification: #{print(s)}\n")
  end

  def sin() do
    e = {:add, {:sin, {:var, :x}}, {:cos, {:var, :x}}}
    d = derive(e, :x)
    s = simplify(d)
    IO.write("Expression: #{print(e)}\n")
    IO.write("Derivative: #{print(d)}\n")
    IO.write("Simplification: #{print(s)}\n")
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

  def derive({:sqrt, e}, v) do
    {:div, derive(e, v), {:mul, {:num, 2}, {:sqrt, e}}}
  end

  def derive({:sin, e}, v) do
    {:mul, {:cos, e}, derive(e, v)}
  end

  def derive({:cos, e}, v) do
    {:sub, {:num, 1}, {:mul, {:sin, e}, derive(e, v)}}
  end

  def simplify({:add, e1, e2}) do
    simplify_add(simplify(e1), simplify(e2))
  end

  def simplify({:sub, e1, e2}) do
    simplify_sub(simplify(e1), simplify(e2))
  end

  def simplify({:mul, e1, e2}) do
    simplify_mul(simplify(e1), simplify(e2))
  end

  def simplify({:div, e1, e2}) do
    simplify_div(simplify(e1), simplify(e2))
  end

  def simplify({:exp, e1, e2}) do
    simplify_exp(simplify(e1), simplify(e2))
  end

  def simplify({:ln, e}) do
    simplify_ln(simplify(e))
  end

  def simplify({:sqrt, e}) do
    simplify_sqrt(simplify(e))
  end

  def simplify(e) do e end

  def simplify_add({:num, 0}, e) do e end
  def simplify_add(e, {:num, 0}) do e end
  def simplify_add({:num, n1}, {:num, n2}) do
    {:num, n1+n2}
  end
  def simplify_add(e1, e2) do
    {:add, e1, e2}
  end

  def simplify_sub({:num, 0}, e) do e end
  def simplify_sub(e, {:num, 0}) do e end
  def simplify_sub({:num, n1}, {:num, n2}) do
    {:num, n1-n2}
  end
  def simplify_sub(e1, e2) do
    {:sub, e1, e2}
  end

  def simplify_mul({:num, 0}, _) do {:num, 0} end
  def simplify_mul(_, {:num, 0}) do {:num, 0} end
  def simplify_mul({:num, 1}, e) do e end
  def simplify_mul(e, {:num, 1}) do e end
  def simplify_mul({:num, n1}, {:num, n2}) do
    {:num, n1*n2}
  end
  def simplify_mul(e, e) do
    {:exp, e, {:num, 2}}
  end
  def simplify_mul(e1, e2) do
    {:mul, e1, e2}
  end

  def simplify_div(e, {:num, 1}) do e end
  def simplify_div(e1, e2) do
    {:div, e1, e2}
  end

  def simplify_exp(_, {:num, 0}) do {:num, 1} end
  def simplify_exp({:num, 0}, _) do {:num, 0} end
  def simplify_exp(e, {:num, 1}) do e end
  def simplify_exp({:num, 1}, _) do {:num, 1} end
  def simplify_exp(e1, e2) do
    {:exp, e1, e2}
  end

  def simplify_ln({:num, 1}) do {:num, 0} end
  def simplify_ln(e) do e end

  def simplify_sqrt({:exp, e, {:num, 2}}) do e end
  def simplify_sqrt(e) do e end

  def print({:num, n}) do "#{n}" end
  def print({:var, v}) do "#{v}" end
  def print({:add, e1, e2}) do "(#{print(e1)} + #{print(e2)})" end
  def print({:sub, e1, e2}) do "(#{print(e1)} - #{print(e2)})" end
  def print({:mul, e1, e2}) do "#{print(e1)} * #{print(e2)}" end
  def print({:div, top, div}) do "(#{print(top)}) / (#{print(div)})" end
  def print({:exp, base, exp}) do "(#{print(base)}) ^ (#{print(exp)})" end
  def print({:ln, e}) do "ln(#{print(e)})" end
  def print({:sqrt, e}) do "sqrt(#{print(e)})" end
  def print({:sin, e}) do "sin(#{print(e)})" end
  def print({:cos, e}) do "cos(#{print(e)})" end
end
