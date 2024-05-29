defmodule HelloWeb.Schema do
  use Absinthe.Schema

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
  end

  query do
    field :menu_items, list_of(:menu_item)
  end
end
