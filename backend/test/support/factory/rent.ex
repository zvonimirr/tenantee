defmodule Tenantee.Factory.Rent do
  @moduledoc """
  Rent factory
  """
  alias Tenantee.Repo
  alias Tenantee.Rent.Schema

  def insert(property_id, tenant_id, attrs \\ []) do
    due_date = Keyword.get(attrs, :due_date, Date.utc_today())
    paid = Keyword.get(attrs, :paid, false)

    %Schema{}
    |> Schema.changeset(%{
      property_id: property_id,
      tenant_id: tenant_id,
      due_date: due_date,
      paid: paid
    })
    |> Repo.insert!()
  end
end
