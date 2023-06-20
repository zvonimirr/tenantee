defmodule Tenantee.Schema.CommunicationChannel do
  @moduledoc """
  Communication Channel Ecto Schema.
  """
  alias Tenantee.Schema.Tenant

  use Ecto.Schema
  import Ecto.Changeset

  @typedoc """
  A communication channel. Has a type and a value.
  Both are free text fields and can be used to store
  any kind of communication channel, e.g. email, phone number, etc.

  Belongs to a tenant.
  """

  @type t :: %__MODULE__{
          id: integer(),
          type: String.t(),
          value: String.t(),
          tenant_id: integer(),
          tenant: Tenant.t(),
          inserted_at: DateTime.t(),
          updated_at: DateTime.t()
        }

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
