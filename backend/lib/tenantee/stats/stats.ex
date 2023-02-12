defmodule Tenantee.Stats do
  @moduledoc """
  This module contains all the stats related functions.
  """
  alias Tenantee.Utils.Currency
  alias Tenantee.Rent
  alias Tenantee.Property
  alias Tenantee.Preferences
  require Decimal

  def get_monthly_revenue(property) do
    with price <- property.price,
         converted_price <- Currency.convert(price),
         {:ok, revenue} <- Money.mult(converted_price, Enum.count(property.tenants)),
         {:ok, taxed_revenue} <- apply_tax(revenue, property.tax_percentage) do
      Money.round(taxed_revenue, currency_digits: 2)
    end
  end

  def get_debt(tenant) do
    with unpaid_rents <- Rent.get_unpaid_rents_by_tenant_id(tenant.id),
         properties <- Enum.map(unpaid_rents, &Property.get_property(&1.property_id)),
         properties <- Enum.reject(properties, fn {status, _} -> status != :ok end),
         prices <- Enum.map(properties, fn {:ok, p} -> Currency.convert(p.price) end),
         {:ok, currency} <- Preferences.get_preference(:default_currency, :USD),
         total_price <- sum_money(prices, currency) do
      if Decimal.gt?(total_price.amount, Decimal.new(0)) do
        Money.round(total_price, currency_digits: 2)
      else
        nil
      end
    end
  end

  def get_income(tenant) do
    with properties <- Property.get_properties_of_tenant(tenant.id),
         prices <- Enum.map(properties, &Currency.convert(&1.price)),
         {:ok, currency} <- Preferences.get_preference(:default_currency, :USD),
         total_price <- sum_money(prices, currency) do
      if Decimal.gt?(total_price.amount, Decimal.new(0)) do
        Money.round(total_price, currency_digits: 2)
      else
        nil
      end
    end
  end

  defp apply_tax(income, tax_percentage) do
    if Decimal.is_decimal(tax_percentage) and Decimal.gt?(tax_percentage, Decimal.new(0)) do
      with {:ok, tax} <-
             Money.mult(income, Decimal.div(tax_percentage, 100) |> Decimal.to_float()) do
        Money.sub(income, tax)
      end
    else
      {:ok, income}
    end
  end

  defp sum_money([], currency), do: Money.new("0", currency)

  defp sum_money([money], _currency), do: money

  defp sum_money(moneys, _currency) do
    [money | other_moneys] = moneys

    Enum.reduce(other_moneys, money, fn money, total_money ->
      with {:ok, added_money} <- Money.add(money, total_money) do
        added_money
      end
    end)
  end
end
