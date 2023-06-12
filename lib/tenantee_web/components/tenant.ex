defmodule TenanteeWeb.Components.Tenant do
  @moduledoc """
  Provides UI components for the Tenant context.
  """
  use Phoenix.Component
  import TenanteeWeb.CoreComponents

  @doc """
  Renders a tenant card.
  """
  attr :tenant, :map, required: true

  def card(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 shadow-lg border border-gray-200 rounded-lg p-4">
      <div class="flex flex-row justify-between">
        <h1 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
          <.icon name="hero-user" class="w-8 h-8" />
          <%= @tenant.first_name %> <%= @tenant.last_name %>
        </h1>
        <.button
          class="bg-red-500 text-white hover:bg-red-600"
          phx-click={open_confirm_modal(@tenant.id)}
        >
          <.icon name="hero-trash" class="w-4 h-4" /> Delete
        </.button>
      </div>
      <a href={"/tenants/#{@tenant.id}"}>
        <.button>
          <.icon name="hero-pencil" class="w-4 h-4" /> Edit
        </.button>
      </a>
    </div>
    """
  end
end
