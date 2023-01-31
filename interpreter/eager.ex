defmodule Eager do
  def eval_expr({:atm, id}, _) do {:ok, id} end

  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil -> :error
      {_, str} -> {:ok, str}
    end
  end

  def eval_expr({:cons, head, tail}, env) do
    case eval_expr(head, env) do
      :error -> :error
      {:ok, str} -> case eval_expr(tail, env) do
        :error -> :error
        {:ok, ts} -> {:ok, {str, ts}}
      end
    end
  end

  def eval_match(:ignore, _, env) do {:ok, env} end

  def eval_match({:atm, id}, id, env) do {:ok, env} end

  def eval_match({:var, id}, str, env) do
    case Env.lookup(id, env) do
      nil -> {:ok, Env.add(id, str, env)}
      {_, ^str} -> {:ok, env}
      {_, _} -> :fail
    end
  end

  def eval_match({:cons, hp, tp}, {hs, ts}, env) do
    case eval_match(hp, hs, env) do
      :fail -> :fail
      {_, tenv} -> eval_match(tp, ts, tenv)
    end
  end

  def eval_match(_, _, _) do :fail end

end
