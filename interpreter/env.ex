defmodule Env do
  def new() do [] end

  def add(id, struct, []) do [{id, struct}] end
  def add(id, struct, env) do [{id, struct}|remove(id, env)] end

  def lookup(_, []) do nil end
  def lookup(id, [{id, struct}|_]) do {id, struct} end
  def lookup(id, [_|tail]) do lookup(id, tail) end

  def remove(_, nil) do [] end
  def remove(_, []) do [] end
  def remove([], env) do env end
  def remove([id|tail], env) do remove(id, remove(tail, env)) end
  def remove(id, [{id, _}|tail]) do tail end
  def remove(id, [head|tail]) do [head|remove(id, tail)] end

  def closure([], env) do env end
  def closure([var|vars], env) do
    case lookup(var, env) do
      nil -> :error
      {_, _} -> closure(vars, env)
    end
  end

  def args([], _, env) do env end
  def args([parameter|parameters], [struct|structs], env) do
    env = add(parameter, struct, env)
    args(parameters, structs, env)
  end

end
