defmodule Tenantee.Schema.Tenant do
  @moduledoc """
  Tenant Ecto Schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "tenants" do
    field :first_name, :string
    field :last_name, :string

    timestamps()
  end

  def changeset(tenant, attrs \\ %{}) do
    tenant
    |> cast(attrs, [:first_name, :last_name])
    |> validate_required([:first_name, :last_name])
  end
end
