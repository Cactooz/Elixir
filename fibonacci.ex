defmodule Fibonacci do
  def fib(0) do 0 end
  def fib(1) do 1 end
  def fib(n) do
    fib(n - 1) + fib(n - 2)
  end
end

defmodule Fibonacci2 do
  def fib() do
    fn() -> fib(0,1) end
  end
  def fib(f1, f2) do
    [f1|fn() -> fib(f2,f1+f2) end]
  end
end
