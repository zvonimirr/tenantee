defmodule Tenantee.Stats do
  @moduledoc """
  This module contains all the stats related functions.
  """
  alias Tenantee.Utils.Currency
  alias Tenantee.Rent
  alias Tenantee.Property

  def get_monthly_revenue(property) do
    with price <- Currency.convert(property.price),
         {:ok, revenue} <- Money.mult(price, Enum.count(property.tenants)) do
      revenue
    end
  end

  def get_debt(tenant) do
    with unpaid_rents <- Rent.get_unpaid_rents_by_tenant_id(tenant.id),
         properties <- Enum.map(unpaid_rents, &Property.get_property(&1.property_id)),
         [price | prices] <-
           Enum.map(properties, fn {:ok, property} -> Currency.convert(property.price) end) do
      Enum.reduce(prices, price, fn price, acc -> Money.add(price, acc) |> elem(1) end)
    end
  end
end
