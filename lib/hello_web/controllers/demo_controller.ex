defmodule HelloWeb.DemoController do
  use HelloWeb, :controller

  def demo(conn, _param) do
    render(conn, :demo)
  end
end
