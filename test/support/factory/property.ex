defmodule Tenantee.Test.Factory.Property do
  @moduledoc """
  Property factory for Tenantee tests.
  """
  alias Tenantee.Schema.Property
  alias Tenantee.Repo

  @doc """
  Generates and inserts a property with the given `attrs`
  or the default attributes if none are given.
  """
  @spec generate_property(Keyword.t()) :: {:ok, term()} | {:error, term()}
  def generate_property(attrs \\ []) do
    name = Keyword.get(attrs, :name, Faker.Company.En.name())
    description = Keyword.get(attrs, :description, Faker.Company.En.bs())
    address = Keyword.get(attrs, :address, Faker.Address.En.street_address())
    amount = Keyword.get(attrs, :amount, Faker.Commerce.price())
    price = Money.from_float(amount, "USD")

    %Property{}
    |> Property.changeset(%{
      name: name,
      description: description,
      address: address,
      price: price
    })
    |> Repo.insert()
  end
end
