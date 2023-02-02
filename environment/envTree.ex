defmodule EnvTree do
  def new() do  {:node, nil, nil, nil, nil} end

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

  def remove(nil, _) do nil end
  def remove({:node, key, _, left, nil}, key) do left end
  def remove({:node, key, _, nil, right}, key) do right end
  def remove({:node, key, _, left, right}, key) do
    {key, value, newRight} = leftmost(right)
    {:node, key, value, left, newRight}
  end
  def remove({:node, key, value, left, right}, removeKey) when removeKey < key do
    {:node, key, value, remove(left, removeKey), right}
  end
  def remove({:node, key, value, left, right}, removeKey) do
    {:node, key, value, left, remove(right, removeKey)}
  end

  def leftmost({:node, key, value, nil, right}) do
    {key, value, right}
  end
  def leftmost({:node, key, value, left, right}) do
    {leftKey, leftValue, leftRight} = leftmost(left)
    {leftKey, leftValue, {:node, key, value, leftRight, right}}
  end
end
