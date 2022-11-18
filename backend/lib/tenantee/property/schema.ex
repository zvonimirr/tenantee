defmodule Tenantee.Property.Schema do
  use Ecto.Schema

  schema "properties" do
    field :name, :string
    field :description, :string, default: ""
    field :location, :string
    field :price, :float
    field :currency, :string
  end
end
