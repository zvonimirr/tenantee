defmodule TenanteeWeb.TenantLive.Helper do
  @moduledoc """
  Helper functions for properties
  """
  alias Tenantee.Entity.Tenant
  import Phoenix.Component, only: [assign: 3]

  @doc """
  Check if submit button should be disabled
  """
  @spec is_submit_disabled?(map()) :: boolean
  def is_submit_disabled?(assigns) do
    [assigns.first_name, assigns.last_name]
    |> Enum.any?(&(&1 == ""))
  end

  @doc """
  Assigns the default properties to the socket
  """
  @spec default(term) :: term
  def default(socket) do
    socket
    |> assign(:first_name, "")
    |> assign(:last_name, "")
    |> assign(:created, false)
  end

  @doc """
  Assigns the properties to the socket from the tenant
  """
  @spec default(term(), map()) :: term
  def default(socket, %{"id" => id}) do
    with {:ok, tenant} <- Tenant.get(id) do
      socket
      |> assign(:first_name, tenant.first_name)
      |> assign(:last_name, tenant.last_name)
      |> assign(:communication_channels, tenant.communication_channels)
      |> assign(:id, id)
    end
  end
end
