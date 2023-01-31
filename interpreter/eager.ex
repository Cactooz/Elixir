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

end
