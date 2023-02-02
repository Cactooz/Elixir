defmodule Eager do
  def eval(seq) do eval_seq(seq, []) end

  def eval_expr({:atm, id}, _) do {:ok, id} end
  def eval_expr({:var, id}, env) do
    case Env.lookup(id, env) do
      nil -> :error
      {_, struct} -> {:ok, struct}
    end
  end
  def eval_expr({:cons, head, tail}, env) do
    case eval_expr(head, env) do
      :error -> :error
      {:ok, struct} -> case eval_expr(tail, env) do
        :error -> :error
        {:ok, tailstruct} -> {:ok, {struct, tailstruct}}
      end
    end
  end
  def eval_expr({:case, expr, clause}, env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, struct} -> eval_cls(clause, struct, env)
    end
  end
  def eval_expr({:lambda, parameters, freeVars, seq}, env) do
    case Env.closure(freeVars, env) do
      :error -> :error
      _ -> {:ok, {:closure, parameters, seq, env}}
    end
  end
  def eval_expr({:apply, expr, args}, env) do
    case eval_expr(expr, env) do
      :error -> :error
      {:ok, {:closure, parameters, seq, closure}} ->
        case eval_args(args, env) do
          :error -> :error
          {:ok, strs} ->
            env = Env.args(parameters, strs, closure)
            eval_seq(seq, env)
        end
    end
  end
  def eval_expr({:fun, id}, _) do
    {parameters, seq} = apply(Prgm, id, [])
    {:ok, {:closure, parameters, seq, Env.new()}}
  end

  def eval_match(:ignore, _, env) do {:ok, env} end
  def eval_match({:atm, id}, id, env) do {:ok, env} end
  def eval_match({:var, id}, struct, env) do
    case Env.lookup(id, env) do
      nil -> {:ok, Env.add(id, struct, env)}
      {_, ^struct} -> {:ok, env}
      {_, _} -> :fail
    end
  end
  def eval_match({:cons, headPattern, tailPattern}, {headStruct, tailstruct}, env) do
    case eval_match(headPattern, headStruct, env) do
      :fail -> :fail
      {_, tailEnv} -> eval_match(tailPattern, tailstruct, tailEnv)
    end
  end
  def eval_match(_, _, _) do :fail end

  def eval_scope(pattern, env) do
    Env.remove(extract_vars(pattern), env)
  end

  def extract_vars(pattern) do extract_vars(pattern, []) end
  def extract_vars({:var, var}, vars) do [var|vars] end
  def extract_vars(_, vars) do vars end

  def eval_seq([exp], env) do eval_expr(exp, env) end
  def eval_seq([{:match, pattern, exp}|tail], env) do
    case eval_expr(exp, env) do
      :error -> :error
      {:ok, struct} ->
        env = eval_scope(pattern, env)
        case eval_match(pattern, struct, env) do
          :fail -> :error
          {:ok, env} -> eval_seq(tail, env)
        end
    end
  end

  def eval_cls([], _, _) do :error end
  def eval_cls([{:clause, pattern, seq}|clause], struct, env) do
    case eval_match(pattern, struct, eval_scope(pattern, env)) do
      :fail -> eval_cls(clause, struct, env)
      {:ok, env} -> eval_seq(seq, env)
    end
  end

  def eval_args(args, env) do eval_args(args, env, []) end
  def eval_args([], _, strs) do {:ok, Enum.reverse(strs)} end
  def eval_args([arg|args], env, strs) do
    case eval_expr(arg, env) do
      :error -> :error
      {:ok, struct} -> eval_args(args, env, [struct|strs])
    end
  end

end
