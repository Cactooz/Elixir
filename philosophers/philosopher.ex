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

    ref = make_ref()
    Chopstick.async(left, ref)
    Chopstick.async(right, ref)
    case Chopstick.get(ref, 1000) do
      :ok ->
        IO.puts("#{name} received first chopstick")
        sleep(250)
        case Chopstick.get(ref, 1000) do
          :ok ->
            IO.puts("#{name} received second chopstick")
            eat(hunger, strength, left, right, name, controller, ref)
          :no ->
            IO.puts("#{name} stopped waiting second chopstick, strength of #{strength}")
            Chopstick.return(left, ref)
            dream(hunger, strength-1, left, right, name, controller)
        end
      :no ->
        IO.puts("#{name} stopped waiting first chopstick, strength of #{strength}")
        dream(hunger, strength-1, left, right, name, controller)
    end
  end

  def eat(hunger, strength, left, right, name, controller, ref) do
    Chopstick.return(left, ref)
    Chopstick.return(right, ref)
    IO.puts("#{name} ate once")
    dream(hunger-1, strength, left, right, name, controller)
  end

  def sleep(0) do :ok end
  def sleep(time) do
    :timer.sleep(:rand.uniform(time))
  end
end
