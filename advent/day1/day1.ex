defmodule Day1 do
  def getInput(path) do
    {:ok, data} = File.read(path)
    calories = String.split(data, "\r\n\r\n")
    calories = sumListLists(calories)
    Enum.sum(findBiggest(calories, 3))
  end

  def sumList([]) do 0 end
  def sumList([head|tail]) do
    String.to_integer(head) + sumList(tail)
  end

  def sumListLists([]) do [] end
  def sumListLists([head|tail]) do
    list = String.split(head, "\r\n")
    [sumList(list)|sumListLists(tail)]
  end

  def findBiggest(list, n) do
    list = Enum.sort(list, :desc)
    Enum.take(list, n)
  end
end
