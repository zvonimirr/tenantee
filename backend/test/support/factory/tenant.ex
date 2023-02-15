defmodule Tenantee.Factory.Tenant do
  @moduledoc """
  Tenant factory
  """
  alias Tenantee.Repo
  alias Tenantee.Tenant.Schema

  def insert(attrs \\ []) do
    first_name = Keyword.get(attrs, :first_name, "John")
    last_name = Keyword.get(attrs, :last_name, "Doe")

    %Schema{}
    |> Schema.changeset(%{
      first_name: first_name,
      last_name: last_name
    })
    |> Repo.insert!()
  end
end
