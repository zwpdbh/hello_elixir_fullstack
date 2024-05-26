defmodule HelloWeb.DemoHTML do
  use HelloWeb, :html

  embed_templates "demo_html/*"

  def index(assigns) do
    ~H"""
    Hello! Demo
    """
  end
end
