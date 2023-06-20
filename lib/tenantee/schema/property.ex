defmodule Tenantee.Schema.Property do
  @moduledoc """
  Property Ecto Schema.
  """
  alias Tenantee.Schema.Tenant

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  A property with a name, address, price, tenants and optionally a description.
  Tenant is a many-to-many relationship, meaning a property can have many tenants
  and a tenant can have many properties.
  """

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          description: String.t(),
          address: String.t(),
          price: Money.t(),
          tenants: list(Tenant.t()),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

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
