defmodule Chopstick do
  def start() do
    spawn_link(fn -> available() end)
  end

  def quit(stick) do
    send(stick, :quit)
  end

  def request(stick) do
    send(stick, {:request, self()})
  end

  def return(stick, ref) do
    send(stick, {:return, ref})
  end

  def async(stick, ref) do
    send(stick, {:request, ref, self()})
  end

  def get(ref, timeout) do
    receive do
      {:granted, ^ref} -> :ok
      {:granted, _} -> get(ref, timeout)
    after timeout -> :no
    end
  end

  def available() do
    receive do
      {:request, from} ->
        send(from, :granted)
        gone()
      {:request, ref, from} ->
        send(from, {:granted, ref})
        gone(ref)
      :quit -> :ok
    end
  end

  def gone() do
    receive do
      :return -> available()
      :quit -> :ok
    end
  end

  def gone(ref) do
    receive do
      {:return, ^ref} -> available()
      :quit -> :ok
    end
  end
end
