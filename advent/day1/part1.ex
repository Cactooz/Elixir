defmodule Advent do
  def getInput(path) do
    {:ok, data} = File.read(path)
    calories = String.split(data, "\r\n\r\n")
    calories = sumListLists(calories)
    findBiggest(calories)
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

  def findBiggest(list) do
    list = Enum.sort(list)
    List.last(list)
  end
end
