defmodule Temperatures do
  def celsius(fahrenheit) do
    (fahrenheit - 32) * (5 / 9)
  end

  def fahrenheit(celsius) do
    celsius * 1.8 + 32
  end
end

IO.puts(Temperatures.celsius(104))
IO.puts(Temperatures.fahrenheit(40))
