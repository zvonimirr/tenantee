defmodule Tenantee.Factory.Tenant do
  @moduledoc """
  Tenant factory
  """
  alias Tenantee.Repo
  alias Tenantee.Tenant.Schema

  def insert(attrs \\ []) do
    first_name = Keyword.get(attrs, :first_name, "John")
    last_name = Keyword.get(attrs, :last_name, "Doe")
    email = Keyword.get(attrs, :email, "jdoe@jd.com")
    phone = Keyword.get(attrs, :phone, "1234567890")

    %Schema{}
    |> Schema.changeset(%{
      first_name: first_name,
      last_name: last_name,
      email: email,
      phone: phone
    })
    |> Repo.insert!()
  end
end
