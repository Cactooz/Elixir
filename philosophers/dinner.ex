defmodule Dinner do
  def start() do spawn(fn() -> init() end) end

  def init() do
    chopstick1 = Chopstick.start()
    chopstick2 = Chopstick.start()
    chopstick3 = Chopstick.start()
    chopstick4 = Chopstick.start()
    chopstick5 = Chopstick.start()
    controller = self()
    Philosopher.start(5, chopstick1, chopstick2, :arendt, controller)
    Philosopher.start(5, chopstick2, chopstick3, :hypatia, controller)
    Philosopher.start(5, chopstick3, chopstick4, :simone, controller)
    Philosopher.start(5, chopstick4, chopstick5, :elisabeth, controller)
    Philosopher.start(5, chopstick5, chopstick1, :ayn, controller)
    wait(5, {chopstick1, chopstick2, chopstick3, chopstick4, chopstick5})
  end

  def wait(0, chopsticks) do
    Enum.each(chopsticks, fn(stick) -> Chopstick.quit(stick) end)
  end
  def wait(time, chopsticks) do
    receive do
      :done -> wait(time-1, chopsticks)
      :abort -> Process.exit(self(), :kill)
    end
  end
end
