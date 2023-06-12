defmodule Tenantee.Schema.Property do
  @moduledoc """
  Property Ecto Schema.
  """
  alias Tenantee.Schema.Tenant

  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :name, :string
    field :description, :string, default: ""
    field :address, :string
    field :price, Money.Ecto.Composite.Type

    many_to_many(:tenants, Tenant, join_through: "leases", on_replace: :delete)

    timestamps()
  end

  def changeset(property, params \\ %{}) do
    property
    |> cast(params, [:name, :description, :address, :price])
    |> validate_required([:name, :address, :price])
  end
end
