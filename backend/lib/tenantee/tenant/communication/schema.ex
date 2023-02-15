defmodule Tenantee.Tenant.Communication.Schema do
  @moduledoc """
  This module contains the schema for the communication table.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Tenantee.Tenant.Schema, as: Tenant

  schema "communication_channels" do
    field :type, :string
    field :value, :string

    belongs_to :tenant, Tenant

    timestamps()
  end

  def changeset(communication, attrs) do
    communication
    |> cast(attrs, [:type, :value])
    |> cast_assoc(:tenant)
    |> validate_required([:type, :value])
  end
end
