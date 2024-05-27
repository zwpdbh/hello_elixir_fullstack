defmodule HelloWeb.CssComponent.Ch01 do
  use Phoenix.LiveComponent

  def render(assigns) do
    ~H"""
    <div>
      <h2>CSS example for Ch01</h2>
    </div>
    """
  end
end
