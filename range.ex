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


  def foldl({:range, from, to}, sum, f) do
    if(from <= to) do
      foldl({:range, from+1, to}, f.(from, sum), f)
    else
      sum
    end
  end

  def map(range, f) do
    Enum.reverse(map(range, [], f))
  end
  def map({:range, from, to}, acc, f) do
    if(from <= to) do
      map({:range, from+1, to}, [f.(from)|acc], f)
    end
  end

  def filter(range, f) do
    Enum.reverse(filter(range, [], f))
  end
  def filter({:range, from, to}, acc, f) do
    if(from <= to) do
      if(f.(from)) do
        filter({:range, from+1, to}, [from|acc], f)
      else
        filter({:range, from+1, to}, acc, f)
      end
    else
      acc
    end
  end

  def take(range, n) do Enum.reverse(take(range, [], n)) end
  def take({:range, from, to}, acc, n) do
    if(from <= to) do
      if(n > 0) do
        take({:range, from+1, to}, [from|acc], n-1)
      else
        acc
      end
    else
      acc
    end
  end
end
