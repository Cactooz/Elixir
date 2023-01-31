defmodule Env do
  def new() do  {:node, nil, nil, nil, nil} end

  def add(id, struct, nil) do
    {:node, id, struct, nil, nil}
  end
  def add(id, struct, {:node, id, _, left, right}) do
    {:node, id, struct, left, right}
  end
  def add(addId, addStruct, {:node, id, struct, left, right}) when addId < id do
    {:node, id, struct, add(addId, addStruct, left), right}
  end
  def add(addId, addStruct, {:node, id, struct, left, right}) do
    {:node, id, struct, left, add(addId, addStruct, right)}
  end

  def lookup(_, nil) do nil end
  def lookup(id, {:node, id, struct, _, _}) do
    {id, struct}
  end
  def lookup(lookupId, {:node, id, _, left, _}) when lookupId < id do
    lookup(lookupId, left)
  end
  def lookup(lookupId, {:node, _, _, _, right}) do
    lookup(lookupId, right)
  end

  def remove(_, nil) do nil end
  def remove([], env) do env end
  def remove([id|tail], env) do remove(id, remove(tail, env)) end
  def remove(id, {:node, id, _, left, nil}) do left end
  def remove(id, {:node, id, _, nil, right}) do right end
  def remove(id, {:node, id, _, left, right}) do
    {id, struct, newRight} = leftmost(right)
    {:node, id, struct, left, newRight}
  end
  def remove(removeId, {:node, id, struct, left, right}) when removeId < id do
    {:node, id, struct, remove(removeId, left), right}
  end
  def remove(removeId, {:node, id, struct, left, right}) do
    {:node, id, struct, left, remove(removeId, right)}
  end

  def leftmost({:node, id, struct, nil, right}) do
    {id, struct, right}
  end
  def leftmost({:node, id, struct, left, right}) do
    {leftId, leftStruct, leftRight} = leftmost(left)
    {leftId, leftStruct, {:node, id, struct, leftRight, right}}
  end
end
