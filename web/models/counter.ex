defmodule Countdown.Counter do
  def start_link do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  def reset do
    Agent.get_and_update(__MODULE__, fn(n) -> {0, 0} end, 5000)
  end

  def value do
    Agent.get(__MODULE__, fn(n) -> n end, 5000)
  end

  def limit do
    100
  end

  def count do
    cond do
      __MODULE__.value + 1 >= __MODULE__.limit -> {:overflow, __MODULE__.reset}
      true -> {:ok, Agent.get_and_update(__MODULE__, fn(n) -> {n + 1, n + 1} end, 5000)}
    end
  end

  def set(value) do
    cond do
      value >= __MODULE__.limit -> {:overflow, __MODULE__.reset}
      true -> {:ok, Agent.update(__MODULE__, fn(_n) -> value end, 5000)}
    end
  end
end
