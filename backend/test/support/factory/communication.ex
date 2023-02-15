defmodule Tenantee.Factory.Communication do
  @moduledoc """
  Communication factory
  """
  alias Tenantee.Repo
  alias Tenantee.Tenant.Communication.Schema
  alias Tenantee.Tenant.Schema, as: Tenant

  def insert(tenant_id, attrs \\ []) do
    tenant = Repo.get(Tenant, tenant_id)
    type = Keyword.get(attrs, :type, "email")
    value = Keyword.get(attrs, :value, "test")

    Schema.changeset(
      %Schema{},
      %{
        type: type,
        value: value,
        tenant: Map.from_struct(tenant)
      }
    )
    |> Repo.insert!()
  end
end
