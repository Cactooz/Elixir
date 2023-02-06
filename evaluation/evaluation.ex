defmodule Evaluation do
  @type literal() :: {:num, number()} | {:var, atom()}

  @type expr() :: literal() |
  {:add, expr(), expr()} |
  {:sub, expr(), expr()} |
  {:mul, expr(), expr()} |
  {:div, expr(), expr()} |
  {:q, {:num, literal()}, {:num, literal()}}

  def eval(_, {:num, num}) do {:num, num} end
  def eval(env, {:var, var}) do
    {_, x} = EnvTree.lookup(env, var)
    {:num, x}
  end
  def eval(env, {:add, e1, e2}) do add(eval(env, e1), eval(env, e2)) end
  def eval(env, {:sub, e1, e2}) do sub(eval(env, e1), eval(env, e2)) end
  def eval(env, {:mul, e1, e2}) do mul(eval(env, e1), eval(env, e2)) end
  def eval(env, {:div, e1, e2}) do d(eval(env, e1), eval(env, e2)) end
  def eval(_, {:q, e1, e2}) do reduce(e1, e2) end

  def add({:q, n1, d1}, {:q, n2, d2}) do {:q, (n1*d2)+(n2*d1), d1*d2} end
  def add({:num, n1}, {:q, n2, d}) do {:q, (n1*d)+n2, d} end
  def add({:q, n1, d}, {:num, n2}) do {:q, n1+(n2*d), d} end
  def add({:num, n1}, {:num, n2}) do {:num, n1+n2} end

  def sub({:q, n1, d1}, {:q, n2, d2}) do {:q, (n1*d2)-(n2*d1), d1*d2} end
  def sub({:num, n1}, {:q, n2, d}) do {:q, (n1*d)-n2, d} end
  def sub({:q, n1, d}, {:num, n2}) do {:q, n1-(n2*d), d} end
  def sub({:num, n1}, {:num, n2}) do {:num, n1-n2} end

  def mul({:q, n1, d1}, {:q, n2, d2}) do {:q, n1*n2, d1*d2} end
  def mul({:num, n1}, {:q, n2, d}) do {:q, n1*n2, d} end
  def mul({:q, n1, d}, {:num, n2}) do {:q, n1*n2, d} end
  def mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end

  def d(_, {:num, 0}) do {:error, "Division with 0"} end
  def d({:num, n}, {:q, q1, q2}) do reduce(n*q2, q1) end
  def d({:num, n1}, {:num, n2}) do
    if rem(n1, n2) == 0 do
      {:num, trunc(n1/n2)}
    else
      reduce(n1, n2)
    end
  end

  def gcd(n, 0) do n end
  def gcd(n1, n2) do gcd(n2, rem(n1, n2)) end

  def reduce(n, 1) do {:num, n} end
  def reduce(e1, e2) do
    {:q, trunc(e1/gcd(e1,e2)), trunc(e2/gcd(e1,e2))}
  end

  def print({:num, n}) do "#{n}" end
  def print({:q, top, div}) do "#{print(top)}/#{print(div)}" end
  def print(n) do "#{n}" end
end
