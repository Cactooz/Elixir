defmodule Range do
  def new(from, to) do {:range, from, to} end

  """
  def sum({:range, from, to}) do
    if(from <= to) do
      from + sum({:range, from+1, to})
    else
      0
    end
  end
  """

  def sum(range) do sum(range, 0) end
  def sum({:range, from, to}, sum) do
    if(from <= to) do
      sum({:range, from+1, to}, sum+from)
    else
      sum
    end
  end

end
