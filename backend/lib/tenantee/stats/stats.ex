defmodule Tenantee.Stats do
  @moduledoc """
  This module contains all the stats related functions.
  """
  alias Tenantee.Utils.Currency

  def get_monthly_revenue(property) do
    with price <- Currency.convert(property.price),
         {:ok, revenue} <- Money.mult(price, Enum.count(property.tenants)) do
      revenue
    else
      _error -> nil
    end
  end
end
