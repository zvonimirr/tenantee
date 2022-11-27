defmodule Tenantee.Utils.Currency do
  @moduledoc """
  This module provides utility functions for working with currencies.
  """
  alias Tenantee.Preferences

  @doc """
  Checks if the given currency is valid.
  """
  def valid?(currency) do
    currencies = Cldr.known_currencies() |> Enum.map(&Atom.to_string(&1))

    if currency in currencies do
      :ok
    else
      {:error, "Invalid currency"}
    end
  end

  @doc """
  Convert the given amount to the given currency.
  """
  def convert(%Money{
        amount: amount,
        currency: old_currency
      }) do
    with money <- Money.new(amount, old_currency),
         {:ok, preference} <- Preferences.get_preference("default_currency"),
         :ok <- valid?(preference.value) do
      Money.to_currency(money, preference.value)
    end
  end
end
