defmodule Philosopher do
  def start(hunger, left, right, name, controller) do
    spawn_link(fn() -> dream(hunger, left, right, name, controller) end)
  end

  def dream(0, left, right, name, controller) do
    send(controller, :done)
  end
  def dream(hunger, left, right, name, controller) do
    sleep(300)
    wait(hunger, left, right, name, controller)
  end

  def wait(hunger, left, right, name, controller) do
    case Chopstick.request(left) do
      :ok ->
        case Chopstick.request(right) do
          :ok -> eat(hunger, left, right, name, controller)
        end
    end
  end

  def eat(hunger, left, right, name, controller) do
    Chopstick.return(left)
    Chopstick.return(right)
    dream(hunger-1, left, right, name, controller)
  end

  def sleep(0) do :ok end
  def sleep(time) do
    :timer.sleep(:rand.uniform(time))
  end
end
