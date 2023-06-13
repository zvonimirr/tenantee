defmodule Tenantee.Test.Factory.Tenant do
  @moduledoc """
  Tenant factory for Tenantee tests.
  """
  alias Tenantee.Schema.Tenant
  alias Tenantee.Repo

  @doc """
  Generates and inserts a tenant with the given `attrs`
  or the default attributes if none are given.
  """
  @spec generate_tenant(Keyword.t()) :: {:ok, term()} | {:error, Ecto.Changeset.t()}
  def generate_tenant(attrs \\ []) do
    first_name = Keyword.get(attrs, :first_name, Faker.Person.first_name())
    last_name = Keyword.get(attrs, :last_name, Faker.Person.last_name())

    %Tenant{}
    |> Tenant.changeset(%{
      first_name: first_name,
      last_name: last_name
    })
    |> Repo.insert()
  end
end
