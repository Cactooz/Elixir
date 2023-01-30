defmodule Evaluation do
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

  def add({:q, {:num, n1}, {:num, d1}}, {:q, {:num, n2}, {:num, d2}}) do
    {:q, {:num, (n1*d2)+(n2*d1)}, {:num, d1*d2}}
  end
  def add({:num, n1}, {:q, {:num, n2}, {:num, d}}) do
    {:q, {:num, (n1*d)+n2}, {:num, d}}
  end
  def add({:q, {:num, n1}, {:num, d}}, {:num, n2}) do
    {:q, {:num, n1+(n2*d)}, {:num, d}}
  end
  def add({:num, n1}, {:num, n2}) do {:num, n1+n2} end

  def sub({:q, {:num, n1}, {:num, d1}}, {:q, {:num, n2}, {:num, d2}}) do
    {:q, {:num, (n1*d2)-(n2*d1)}, {:num, d1*d2}}
  end
  def sub({:num, n1}, {:q, {:num, n2}, {:num, d}}) do
    {:q, {:num, (n1*d)-n2}, {:num, d}}
  end
  def sub({:q, {:num, n1}, {:num, d}}, {:num, n2}) do
    {:q, {:num, n1-(n2*d)}, {:num, d}}
  end
  def sub({:num, n1}, {:num, n2}) do {:num, n1-n2} end

  def mul({:q, {:num, n1}, {:num, d1}}, {:q, {:num, n2}, {:num, d2}}) do
    {:q, {:num, n1*n2}, {:num, d1*d2}}
  end
  def mul({:num, n1}, {:q, {:num, n2}, {:num, d}}) do
    {:q, {:num, n1*n2}, {:num, d}}
  end
  def mul({:q, {:num, n1}, {:num, d}}, {:num, n2}) do
    {:q, {:num, n1*n2, d}}
  end
  def mul({:num, n1}, {:num, n2}) do {:num, n1*n2} end

  def d({:num, n1}, {:num, n2}) do
    if rem(n1, n2) == 0 do
      {:num, trunc(n1/n2)}
    else
      {:q, {:num, n1}, {:num, n2}}
    end
  end

  def gcd(n, 0) do n end
  def gcd({:num, n1}, {:num, n2}) do {:num, gcd(n2, rem(n1, n2))} end

  def reduce({:num, e1}, {:num, e2}) do
    {:q, {:num, trunc(e1/gcd(e1,e2))}, {:num, trunc(e2/gcd(e1,e2))}}
  end
end
