defmodule Tenantee.Property.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :name, :string
    field :description, :string, default: ""
    field :location, :string
    field :price, :float
    field :currency, :string

    timestamps()
  end

  def changeset(property, attrs) do
    property
    |> cast(attrs, [:name, :description, :location, :price, :currency])
    |> validate_required([:name, :location, :price, :currency])
  end
end
