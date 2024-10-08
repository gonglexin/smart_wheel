defmodule SmartWheelWeb.WheelLive do
  use SmartWheelWeb, :live_view

  alias SmartWheel.Openai

  def mount(_params, _session, socket) do
    socket = assign(socket, items: ["Apple", "Pear", "Grape"])
    {:ok, socket}
  end

  def handle_event("add_item", %{"item" => ""}, socket) do
    {:noreply, socket}
  end

  def handle_event("add_item", %{"item" => item}, socket) do
    items = [item | socket.assigns.items]
    {:noreply, assign(socket, items: items)}
  end

  def handle_event("populate_ai_items", %{"prompt" => prompt}, socket) do
    case Openai.populate_items(prompt) do
      {:ok, items} ->
        {:noreply, assign(socket, items: items)}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end

  def handle_event("clear_items", _, socket) do
    {:noreply, assign(socket, items: [])}
  end

  def render(assigns) do
    ~H"""
    <.svelte name="Wheel" socket={@socket} props={%{items: @items}} />
    """
  end
end
