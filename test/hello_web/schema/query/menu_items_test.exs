defmodule HelloWeb.Schema.Query.MenuItemsTest do
  use HelloWeb.ConnCase, async: true

  setup do
    Hello.Seeds.run()
  end

  @query """
  {
    menuItems {
      name
    }
  }
  """

  test "menuItems filed returns menu items" do
    conn = build_conn()
    conn = get conn, "/api", query: @query

    assert json_response(conn, 200) == %{
             "data" => %{
               "menuItems" => [
                 %{"name" => "Reuben"},
                 %{"name" => "Croque Monsieur"},
                 %{"name" => "Muffuletta"},
                 %{"name" => "Bánh mì"},
                 %{"name" => "Vada Pav"},
                 %{"name" => "French Fries"},
                 %{"name" => "Papadum"},
                 %{"name" => "Pasta Salad"},
                 %{"name" => "Water"},
                 %{"name" => "Soft Drink"},
                 %{"name" => "Lemonade"},
                 %{"name" => "Masala Chai"},
                 %{"name" => "Vanilla Milkshake"},
                 %{"name" => "Chocolate Milkshake"}
               ]
             }
           }
  end
end

# mix test test/hello_web/schema/query/menu_items_test.exs
