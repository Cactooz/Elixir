defmodule EnvTree do
  def new(tree, []) do tree end
  def new(tree, [{key, value}|tail]) do new(add(tree, key, value), tail) end

  def add(nil, key, value) do
    {:node, key, value, nil, nil}
  end
  def add({:node, key, _, left, right}, key, value) do
    {:node, key, value, left, right}
  end
  def add({:node, key, value, left, right}, addKey, addValue) when addKey < key do
    {:node, key, value, add(left, addKey, addValue), right}
  end
  def add({:node, key, value, left, right}, addKey, addValue) do
    {:node, key, value, left, add(right, addKey, addValue)}
  end

  def lookup(nil, _) do nil end
  def lookup({:node, key, value, _, _}, key) do
    {key, value}
  end
  def lookup({:node, key, _, left, _}, lookupKey) when lookupKey < key do
    lookup(left, lookupKey)
  end
  def lookup({:node, _, _, _, right}, lookupKey) do
    lookup(right, lookupKey)
  end
end
