defmodule Tenantee.Schema.Tenant do
  @moduledoc """
  Tenant Ecto Schema.
  """
  alias Tenantee.Schema.Property

  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :first_name, :string
    field :last_name, :string

    many_to_many(:properties, Property, join_through: "leases", on_replace: :delete)

    timestamps()
  end

  def changeset(tenant, attrs \\ %{}) do
    tenant
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
    |> put_assoc(:properties, [])
  end

  def set_properties(%__MODULE__{} = tenant, properties) do
    tenant
    |> change()
    |> put_assoc(:properties, properties)
  end
end
