defmodule SmartWheelWeb.WheelLive do
  use SmartWheelWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.svelte name="Wheel" socket={@socket} />
    """
  end
end
