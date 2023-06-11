defmodule TenanteeWeb.HomeLive do
  alias Tenantee.Config
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    with value <- Config.get(:name, "landlord") do
      {:ok, assign(socket, :name, value)}
    end
  end

  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold">Hey there, <%= @name %>.</h1>
    <p class="text-gray-600">Thank you for trying out Tenantee!</p>
    <hr class="my-5" />
    """
  end
end
