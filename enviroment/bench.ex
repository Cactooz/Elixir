defmodule Bench do
  def bench(i, n) do
    #Create list of random numbers
    seq = Enum.map(1..i, fn(_) -> :rand.uniform(i) end)

    #Remove duplicates and add :foo to the tuples
    list = Enum.reduce(seq, EnvList.new(), fn(e, list) ->
      EnvList.add(list, e, :foo)
    end)

    seq = Enum.map(1..n, fn(_) -> :rand.uniform(i) end)

    #Return time to add new list element
    {add, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        EnvList.add(list, e, :foo)
      end)
    end)

    #Return time to lookup an element in the list
    {lookup, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        EnvList.lookup(list, e)
      end)
    end)

    #Return the time to remove an element in the list
    {remove, _} = :timer.tc(fn() ->
      Enum.each(seq, fn(e) ->
        EnvList.remove(list, e)
      end)
    end)

    {i, add, lookup, remove}
  end

  def bench(n) do
    ls = [16,32,64,128,256,512,1024,2048,4096,8192]

    :io.format("Benchmark with ~w operations, time per operation in us\n", [n])
    :io.format("~6.s~12.s~12.s~12.s\n", ["n", "add", "lookup", "remove"])

    Enum.each(ls, fn(i) ->
      {i, tla, tll, tlr} = bench(i, n)
      :io.format("~6.w~12.2f~12.2f~12.2f\n", [i, tla/n, tll/n, tlr/n])
    end)

  end
end
