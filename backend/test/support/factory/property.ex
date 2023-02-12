defmodule Tenantee.Factory.Property do
  @moduledoc """
  Property factory
  """
  alias Tenantee.Repo
  alias Tenantee.Property.Schema

  def insert(attrs \\ []) do
    name = Keyword.get(attrs, :name, "Property #{Enum.random(1..100)}")
    description = Keyword.get(attrs, :description, "Description for #{name}")
    location = Keyword.get(attrs, :location, "Location for #{name}")
    price = Keyword.get(attrs, :price, Money.new(Enum.random(100..1000), :USD))
    due_date_modifier = Keyword.get(attrs, :due_date_modifier, 5 * 24 * 60 * 60)
    tax_percentage = Keyword.get(attrs, :tax_percentage, 10)

    %Schema{}
    |> Schema.changeset(%{
      name: name,
      description: description,
      location: location,
      price: price,
      due_date_modifier: due_date_modifier,
      tax_percentage: tax_percentage
    })
    |> Repo.insert!()
  end
end
