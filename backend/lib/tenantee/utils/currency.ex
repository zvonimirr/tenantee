defmodule Tenantee.Utils.Currency do
  @moduledoc """
  This module provides utility functions for working with currencies.
  """

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
end
