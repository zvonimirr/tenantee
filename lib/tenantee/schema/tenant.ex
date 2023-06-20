defmodule Tenantee.Schema.Tenant do
  @moduledoc """
  Tenant Ecto Schema.
  """
  alias Tenantee.Schema.{Property, Rent, CommunicationChannel}

  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :first_name, :string
    field :last_name, :string

    has_many(:rents, Rent)
    many_to_many(:properties, Property, join_through: "leases", on_replace: :delete)
    has_many(:communication_channels, CommunicationChannel)

    timestamps()
  end

  def changeset(tenant, attrs \\ %{}) do
    tenant
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
    |> put_assoc(:properties, [])
    |> put_assoc(:communication_channels, [])
  end

  def set_properties(%__MODULE__{} = tenant, properties) do
    tenant
    |> change()
    |> put_assoc(:properties, properties)
  end

  def set_communication_channels(%__MODULE__{} = tenant, communication_channels) do
    tenant
    |> change()
    |> put_assoc(:communication_channels, communication_channels)
  end
end
