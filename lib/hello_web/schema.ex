defmodule HelloWeb.Schema do
  alias Hello.Repo
  alias Hello.Menu
  use Absinthe.Schema

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end

  query do
    field :menu_items, list_of(:menu_item) do
      resolve fn _, _, _ -> {:ok, Repo.all(Menu.Item)} end
    end
  end
end
