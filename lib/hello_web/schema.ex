defmodule HelloWeb.Schema do
  alias HelloWeb.Resolvers
  use Absinthe.Schema

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end

  query do
    field :menu_items, list_of(:menu_item) do
      arg :matching, :string

      resolve(&Resolvers.Menu.menu_items/3)
    end
  end
end
