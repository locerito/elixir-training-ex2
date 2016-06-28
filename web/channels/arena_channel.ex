defmodule Countdown.ArenaChannel do
  use Phoenix.Channel

  alias Countdown.Counter

  def join("arenas:lobby", _message, socket) do
    {:ok, %{counter: Counter.value}, socket}
  end

  def handle_in("count", _message, socket) do
    case Counter.count do
      {:ok, val} -> broadcast! socket, "update",  %{counter: val}
      _ -> broadcast! socket, "update",  %{counter: Counter.value}
    end
    case Counter.value do
      0 -> {:reply, {:ok, %{won: true, counter: Counter.value}}, socket}
      _ -> {:reply, {:ok, %{won: false, counter: Counter.value}}, socket}
    end
  end
end
