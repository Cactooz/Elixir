defmodule Dinner do
  def start(hunger) do
    dinner = spawn(fn() -> init(hunger) end)
    Process.register(dinner, :dinner)
  end

  def init(hunger) do
    chopstick1 = Chopstick.start()
    chopstick2 = Chopstick.start()
    chopstick3 = Chopstick.start()
    chopstick4 = Chopstick.start()
    chopstick5 = Chopstick.start()
    controller = self()
    Philosopher.start(hunger, chopstick1, chopstick2, :arendt, controller)
    Philosopher.start(hunger, chopstick2, chopstick3, :hypatia, controller)
    Philosopher.start(hunger, chopstick3, chopstick4, :simone, controller)
    Philosopher.start(hunger, chopstick4, chopstick5, :elisabeth, controller)
    Philosopher.start(hunger, chopstick5, chopstick1, :ayn, controller)
    wait(5, [chopstick1, chopstick2, chopstick3, chopstick4, chopstick5])
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(stick) -> Chopstick.quit(stick) end)
    Process.unregister(:dinner)
    IO.puts("Dinner finished")
  end
  def wait(time, chopsticks) do
    receive do
      :done -> wait(time-1, chopsticks)
      :abort -> Process.exit(self(), :kill)
    end
  end
end
