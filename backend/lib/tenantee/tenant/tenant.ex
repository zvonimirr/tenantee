defmodule Tenantee.Tenant do
  alias Tenantee.Tenant.Schema
  alias Tenantee.Repo
  import Ecto.Query

  def create_tenant(tenant) do
    %Schema{}
    |> Schema.changeset(tenant)
    |> Repo.insert()
  end

  def get_tenant_by_id(id) do
    Repo.get(Schema, id)
  end

  def get_all_tenants do
    Repo.all(Schema)
  end

  def update_tenant(id, attrs) do
    get_tenant_by_id(id)
    |> Schema.changeset(attrs)
    |> Repo.update()
  end

  def delete_tenant(id) do
    from(t in Schema, where: t.id == ^id)
    |> Repo.delete_all()
  end
end
