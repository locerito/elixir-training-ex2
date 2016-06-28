defmodule Countdown.ArenaChannel do
  use Phoenix.Channel

  alias Countdown.Counter

  def join("arenas:lobby", _message, socket) do
    {:ok, %{counter: Counter.value}, socket}
  end

  def handle_in("count", _message, socket) do
    {status, val} = Counter.count
    broadcast! socket, "update",  %{counter: val}
    case status do
      :ok -> {:reply, {:ok, %{won: false, counter: Counter.value}}, socket}
      :overflow -> {:reply, {:ok, %{won: true, counter: Counter.value}}, socket}
    end
  end
end
