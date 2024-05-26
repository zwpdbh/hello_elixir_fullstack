defmodule HelloWeb.HelloController do
  use HelloWeb, :controller

  def index(conn, _param) do
    render(conn, :index)
  end
end
