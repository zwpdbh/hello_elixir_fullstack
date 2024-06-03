# Convert migration of ecto changeset to plan sql

To convert the Ecto migrations into plain SQL for PostgreSQL, you can write SQL statements that accomplish the same tasks. Here are the equivalent SQL statements for each migration:

### Migration: CreateCategories

```elixir
defmodule Hello.Repo.Migrations.CreateCategories do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add :description, :string
      add :name, :string, null: false

      timestamps()
    end
  end
end
```

**Plain SQL:**

```sql
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    description VARCHAR,
    name VARCHAR NOT NULL,
    inserted_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

### Migration: CreateItems

```elixir
defmodule Hello.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :name, :string, null: false
      add :description, :string
      add :price, :decimal, null: false
      add :added_on, :date, null: false, default: fragment("NOW()")
      add :category_id, references(:categories, on_delete: :nothing)

      timestamps()
    end

    create index(:items, [:category_id])
  end
end
```

**Plain SQL:**

```sql
CREATE TABLE items (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    description VARCHAR,
    price DECIMAL NOT NULL,
    added_on DATE NOT NULL DEFAULT CURRENT_DATE,
    category_id INTEGER REFERENCES categories(id) ON DELETE NO ACTION,
    inserted_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);

CREATE INDEX ON items(category_id);
```

### Migration: CreateItemTags

```elixir
defmodule Hello.Repo.Migrations.CreateItemTags do
  use Ecto.Migration

  def change do
    create table(:item_tags) do
      add :name, :string, null: false
      add :description, :string

      timestamps()
    end
  end
end
```

**Plain SQL:**

```sql
CREATE TABLE item_tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    description VARCHAR,
    inserted_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

### Migration: CreateMenuTagTaggings

```elixir
defmodule Hello.Repo.Migrations.CreateMenuTagTaggings do
  use Ecto.Migration

  def change do
    create table(:items_taggings, primary_key: false) do
      add :item_id, references(:items), null: false
      add :item_tag_id, references(:item_tags), null: false
    end
  end
end
```

**Plain SQL:**

```sql
CREATE TABLE items_taggings (
    item_id INTEGER REFERENCES items(id) NOT NULL,
    item_tag_id INTEGER REFERENCES item_tags(id) NOT NULL
);
```

### Migration: AddIndexForMenuItemNames

```elixir
defmodule Hello.Repo.Migrations.AddIndexForMenuItemNames do
  use Ecto.Migration

  def change do
    create(unique_index(:items, [:name]))
  end
end
```

**Plain SQL:**

```sql
CREATE UNIQUE INDEX ON items(name);
```

### Migration: CreateOrders

```elixir
defmodule Hello.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders) do
      add(:customer_number, :serial)
      add(:items, :map)
      add(:ordered_at, :utc_datetime, null: false, default: fragment("NOW()"))
      add(:state, :string, null: false, default: "created")

      timestamps()
    end
  end
end
```

**Plain SQL:**

```sql
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    customer_number SERIAL,
    items JSONB,
    ordered_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    state VARCHAR NOT NULL DEFAULT 'created',
    inserted_at TIMESTAMP NOT NULL DEFAULT NOW(),
    updated_at TIMESTAMP NOT NULL DEFAULT NOW()
);
```

These SQL statements should create the same database schema as the Ecto migrations you provided. Note that the `jsonb` type is used for the `map` type in PostgreSQL.