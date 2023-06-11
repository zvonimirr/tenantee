defmodule TenanteeWeb.PropertyLive.Helper do
  import Phoenix.Component, only: [assign: 3]

  @moduledoc """
  Helper functions for properties
  """
  alias Tenantee.Entity.Property

  @doc """
  Check if the submit button should be disabled
  """
  @spec is_submit_disabled?(map()) :: boolean
  def is_submit_disabled?(assigns) do
    with {price, ""} <- Float.parse(assigns.price) do
      [
        assigns.name,
        assigns.address,
        assigns.price
      ]
      |> Enum.any?(&(String.length(&1) == 0)) or price <= 0
    else
      _ -> true
    end
  end

  @doc """
  Assigns the default properties to the socket
  """
  @spec default(term) :: term
  def default(socket) do
    socket
    |> assign(:name, "")
    |> assign(:address, "")
    |> assign(:description, "")
    |> assign(:price, "")
    |> assign(:created, false)
  end

  @doc """
  Assigns the properties to the socket from the property
  """
  @spec default(term, map()) :: term
  def default(socket, %{"id" => id}) do
    with {:ok, property} <- Property.get(id) do
      socket
      |> assign(:name, property.name)
      |> assign(:address, property.address)
      |> assign(:description, property.description)
      |> assign(:price, property.price.amount |> to_string())
      |> assign(:id, id)
    end
  end
end
