defmodule Philosopher do
  def start(hunger, left, right, name, controller) do
    spawn_link(fn() -> init(hunger, left, right, name, controller) end)
  end

  defp init(hunger, left, right, name, controller) do
    dream(hunger, left, right, name, controller)
  end

  def dream(0, left, right, name, controller) do
    send(controller, :done)
    IO.puts("#{name} is full")
  end
  def dream(hunger, left, right, name, controller) do
    IO.puts("#{name} is dreaming")
    sleep(1000)
    wait(hunger, left, right, name, controller)
  end

  def wait(hunger, left, right, name, controller) do
    IO.puts("#{name} is waiting")
    case Chopstick.request(left) do
      :ok ->
        IO.puts("#{name} received left chopstick")
        sleep(250)
        case Chopstick.request(right) do
          :ok ->
            IO.puts("#{name} received right chopstick")
            eat(hunger, left, right, name, controller)
        end
    end
  end

  def eat(hunger, left, right, name, controller) do
    Chopstick.return(left)
    Chopstick.return(right)
    IO.puts("#{name} ate once")
    dream(hunger-1, left, right, name, controller)
  end

  def sleep(0) do :ok end
  def sleep(time) do
    :timer.sleep(:rand.uniform(time))
  end
end
