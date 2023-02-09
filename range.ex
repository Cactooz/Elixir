defmodule Range do
  def new(from, to) do {:range, from, to} end

  def sum({:range, from, to}) do
    if(from <= to) do
      from + sum({:range, from+1, to})
    else
      0
    end
  end

end
