defmodule Day1 do
  def getInput(path) do
    {:ok, data} = File.read(path)
    calories = String.split(data, "\r\n\r\n")
    sumListLists(calories)
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

  def findBiggest(path, n) do
    list = getInput(path)
    list = Enum.sort(list, :desc)
    Enum.sum(Enum.take(list, n))
  end
end
