defmodule Tenantee.Schema.CommunicationChannel do
  @moduledoc """
  Communication Channel Ecto Schema.
  """
  alias Tenantee.Schema.Tenant

  use Ecto.Schema
  import Ecto.Changeset

  schema "communication_channels" do
    field :type, :string
    field :value, :string

    belongs_to(:tenant, Tenant)

    timestamps()
  end

  def changeset(rent, attrs) do
    rent
    |> cast(attrs, [:type, :value])
    |> validate_required([:type, :value])
    |> assoc_constraint(:tenant)
  end
end
