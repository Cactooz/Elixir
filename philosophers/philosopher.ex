defmodule Philosopher do
  def start(hunger, strength, left, right, name, controller) do
    spawn_link(fn() -> init(hunger, strength, left, right, name, controller) end)
  end

  defp init(hunger, strength, left, right, name, controller) do
    dream(hunger, strength, left, right, name, controller)
  end

  def dream(0, _strength, _left, _right, name, controller) do
    send(controller, :done)
    IO.puts("#{name} is full")
  end
  def dream(_hunger, 0, _left, _right, name, controller) do
    send(controller, :done)
    IO.puts("#{name} has no more strength")
  end
  def dream(hunger, strength, left, right, name, controller) do
    IO.puts("#{name} is dreaming")
    sleep(1000)
    wait(hunger, strength, left, right, name, controller)
  end

  def wait(hunger, strength, left, right, name, controller) do
    IO.puts("#{name} is waiting")
    case Chopstick.request(left, 1000) do
      :ok ->
        IO.puts("#{name} received left chopstick")
        sleep(250)
        case Chopstick.request(right, 1000) do
          :ok ->
            IO.puts("#{name} received right chopstick")
            eat(hunger, strength, left, right, name, controller)
          :no ->
            IO.puts("#{name} stopped waiting for right chopstick, strength of #{strength}")
            Chopstick.return(left)
            dream(hunger, strength-1, left, right, name, controller)
        end
      :no ->
        IO.puts("#{name} stopped waiting for left chopstick, strength of #{strength}")
        dream(hunger, strength-1, left, right, name, controller)
    end
  end

  def eat(hunger, strength, left, right, name, controller) do
    Chopstick.return(left)
    Chopstick.return(right)
    IO.puts("#{name} ate once")
    dream(hunger-1, strength, left, right, name, controller)
  end

  def sleep(0) do :ok end
  def sleep(time) do
    :timer.sleep(:rand.uniform(time))
  end
end
