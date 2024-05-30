defmodule HelloWeb.Resolvers.Menu do
  alias Hello.Menu

  def menu_items(_, args, _) do
    {:ok, Menu.list_items(args)}
  end
end
