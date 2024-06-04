Currently, the follow example doesn't produce warning during compilation.

```elixir
defmodule Admin do
  defstruct [:id, :name, :permissions]
end

defmodule RegularUser do
  defstruct [:id, :name, :preferences]
end

defmodule Guest do
  defstruct [:id, :name]
end

defmodule Other do
  defstruct [:id, :name]
end

defmodule UserRole do
  @type t :: %Admin{} | %RegularUser{} | %Guest{}

  def all_roles do
    [:admin, :user, :guest]
  end
end

defmodule UserFactory do
  def create_admin(id, name, permissions) do
    %Admin{id: id, name: name, permissions: permissions}
  end

  def create_user(id, name, preferences) do
    %RegularUser{id: id, name: name, preferences: preferences}
  end

  def create_guest(id, name) do
    %Guest{id: id, name: name}
  end
end

defmodule UserHandler do
  @spec describe_role(UserRole.t()) :: String.t()

  def describe_role(%Admin{id: id, name: name, permissions: permissions}) do
    "Admin: #{name} (ID: #{id}) with permissions: #{Enum.join(permissions, ", ")}"
  end

  def describe_role(%RegularUser{id: id, name: name, preferences: preferences}) do
    "User: #{name} (ID: #{id}) with preferences: #{Enum.join(preferences, ", ")}"
  end

  def describe_role(%Guest{id: id, name: name}) do
    "Guest: #{name} (ID: #{id})"
  end

  def describe_role(%Other{id: id, name: name}) do
    "Guest: #{name} (ID: #{id})"
  end
end
```