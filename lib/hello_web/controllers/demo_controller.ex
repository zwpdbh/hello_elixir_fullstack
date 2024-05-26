defmodule HelloWeb.DemoController do
  use HelloWeb, :controller

  def index(conn, _param) do
    render(conn, :index)
  end

  def show(conn, %{"demo_name" => demo_name}) do
    render(conn, :show, demo_name: demo_name)
  end
end
