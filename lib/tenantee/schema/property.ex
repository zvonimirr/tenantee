defmodule Tenantee.Schema.Property do
  @moduledoc """
  Property Ecto Schema.
  """
  alias Tenantee.Schema.{Tenant, Expense}

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  A property with a name, address, price, tenants and optionally a description.
  Tenant is a many-to-many relationship, meaning a property can have many tenants
  and a tenant can have many properties.

  Property is also associated with expenses, which are the expenses that the
  property owner or the tenant has to pay.
  """

  @type t :: %__MODULE__{
          id: integer(),
          name: String.t(),
          description: String.t(),
          address: String.t(),
          price: Money.t(),
          tenants: [Tenant.t()],
          expenses: [Expense.t()],
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

  schema "properties" do
    field :name, :string
    field :description, :string, default: ""
    field :address, :string
    field :price, Money.Ecto.Composite.Type

    many_to_many(:tenants, Tenant, join_through: "leases", on_replace: :delete)
    has_many(:expenses, Expense, on_delete: :delete_all)

    timestamps()
  end

  def changeset(property, attrs \\ %{}) do
    property
    |> cast(attrs, [:name, :description, :address, :price])
    |> validate_required([:name, :address, :price])
  end

  def set_expenses(%__MODULE__{} = property, expenses) do
    property
    |> change()
    |> put_assoc(:expenses, expenses)
  end
end
