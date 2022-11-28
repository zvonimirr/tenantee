defmodule Tenantee.Stats do
  @moduledoc """
  This module contains all the stats related functions.
  """
  alias Tenantee.Utils.Currency
  alias Tenantee.Rent
  alias Tenantee.Property

  def get_monthly_revenue(property) do
    with price <- property.price,
         converted_price <- Currency.convert(price),
         {:ok, revenue} <- Money.mult(converted_price, Enum.count(property.tenants)) do
      Money.round(revenue, currency_digits: 2)
    end
  end

  def get_debt(tenant) do
    with unpaid_rents <- Rent.get_unpaid_rents_by_tenant_id(tenant.id),
         properties <-
           Enum.map(unpaid_rents, &Property.get_property(&1.property_id))
           |> Enum.reject(fn {status, _} -> status != :ok end),
         prices <- Enum.map(properties, fn {:ok, p} -> p.price end),
         converted_prices <- Enum.map(prices, &Currency.convert/1),
         [price | other_prices] <- converted_prices,
         total_price <-
           Enum.reduce(other_prices, price, fn price, total_price ->
             with {:ok, added_price} <- Money.add(price, total_price) do
               added_price
             end
           end) do
      Money.round(total_price, currency_digits: 2)
    end
  end

  def get_income(tenant) do
    with properties <- Property.get_properties_of_tenant(tenant.id),
         prices <- Enum.map(properties, & &1.price),
         converted_prices <- Enum.map(prices, &Currency.convert/1),
         [price | other_prices] <- converted_prices,
         total_price <-
           Enum.reduce(other_prices, price, fn price, total_price ->
             with {:ok, added_price} <- Money.add(price, total_price) do
               added_price
             end
           end) do
      Money.round(total_price, currency_digits: 2)
    end
  end
end
