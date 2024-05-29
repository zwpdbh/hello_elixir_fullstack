defmodule HelloWeb.CssLive do
  alias HelloWeb.CssComponent.Ch01
  use Phoenix.LiveView

  def mount(_params, _session, socket) do
    socket =
      assign(socket,
        score: 0,
        message: "default",
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
          <a href="#{}" phx-click="show_css_demo" phx-value-ch_name="ch01">ch01-basic</a>
        </li>
      </ul>

      <%= show_demo(assigns) %>
    </div>
    """

    # Need to render the conent based on message content.
  end

  def show_demo(%{message: "ch01"} = assigns) do
    ~H"""
    <.live_component module={Ch01} id="ch01_component" />
    """
  end

  def show_demo(%{message: "default"} = assigns) do
    ~H"""
    <h2>click to see other demos</h2>
    """
  end

  def handle_event("show_css_demo", %{"ch_name" => ch_name} = _data, socket) do
    message = "#{[ch_name]}"
    socket = assign(socket, message: message)

    {
      :noreply,
      socket
    }
  end
end
