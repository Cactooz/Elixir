defmodule EnvList do
  def new() do [] end

  def add([], key, value) do [{key, value}] end
  def add(map, key, value) do [{key, value}|remove(map, key)] end

  def lookup([], _) do nil end
  def lookup([{key, value}|_], key) do {key, value} end
  def lookup([_|tail], key) do lookup(tail, key) end

  def remove([], _) do [] end
  def remove([{key, _}|tail], key) do tail end
  def remove([head|tail], key) do [head|remove(tail, key)] end
end
