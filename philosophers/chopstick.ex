defmodule Chopstick do
  def start() do
    stick = spawn_link(fn -> available() end)
  end

  def request(stick) do
    send(stick, {:request, self()})
    receive do
      {:request, from} -> :ok
    end
  end

  def return({:stick, process}) do
    send(process, :return)
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      {:request, from} -> available()
      :quit -> :ok
    end
  end
end
