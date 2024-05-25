defmodule HelloWeb.DemoHTML do
  use HelloWeb, :html

  embed_templates "demo_html/*"

  # def demo(assigns) do
  #   ~H"""
  #   Hello Demos
  #   """
  # end
end
