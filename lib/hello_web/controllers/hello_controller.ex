defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  def demo(conn, _param) do
    render(conn, :index)
  end
end
