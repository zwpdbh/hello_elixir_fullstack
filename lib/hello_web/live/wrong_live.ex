defmodule HelloWeb.WrongLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    socket = assign(socket, score: 0, message: "Make a guess")
    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <h1>Your score: <%= @score %></h1>
    <h2>
      <%= @message %>
    </h2>
    <%= for n <- 1..10 do %>
      <a href="#" phx-click="guess" phx-value-number={n}><%= n %></a>
    <% end %>
    <h2></h2>
    """
  end

  def handle_event("guess", %{"number" => guess} = _data, socket) do
    message = "Your guess: #{guess}. Wrong. Guess again."
    socket = assign(socket, message: message, score: socket.assigns.score - 1)

    {
      :noreply,
      socket
    }
  end
end
