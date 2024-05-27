defmodule HelloWeb.CssLive do
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        score: 0,
        message: "select to show css demo",
        layout: {HelloWeb.Layouts, "mycustom"}
      )

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="">
      <h1>CSS practis demos</h1>

      <ul>
        <li>
          <a href="#{}" phx-click="show-css-demo" phx-value-ch_name="ch01-basic">ch01-basic</a>
        </li>
      </ul>

      <h2><%= @message %></h2>
    </div>
    """

    # Need to render the conent based on message content.
  end

  def handle_event("show-css-demo", %{"ch_name" => ch_name} = _data, socket) do
    message = "Demo #{[ch_name]}"
    socket = assign(socket, message: message)

    {
      :noreply,
      socket
    }
  end
end
