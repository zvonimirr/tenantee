defmodule TenanteeWeb.Components.Property do
  @moduledoc """
  Provides UI components for the Property context.
  """
  alias Tenantee.Entity.Property
  alias Phoenix.LiveView.JS
  alias Tenantee.Cldr
  use Phoenix.Component
  import TenanteeWeb.CoreComponents

  @doc """
  Renders a property card.
  """
  attr :property, :map, required: true
  attr :tenant_count, :integer, required: true

  def card(assigns) do
    ~H"""
    <div class="flex flex-col gap-4 shadow-lg border border-gray-200 rounded-lg p-4">
      <div class="flex flex-row justify-between">
        <h1 class="text-2xl font-bold text-gray-800 flex items-center gap-2">
          <.icon name="hero-home" class="w-8 h-8" />
          <%= @property.name %>
        </h1>
        <abbr title="Delete Property">
          <.button
            class="bg-red-500 text-white hover:bg-red-600"
            phx-click={open_confirm_modal(@property.id)}
          >
            <.icon name="hero-trash" class="w-4 h-4" />
          </.button>
        </abbr>
      </div>
      <hr class="border border-gray-200 w-full" />
      <p class="text-gray-600">
        <span class="font-bold">Address:</span>
        <%= @property.address %>
      </p>
      <p class="text-gray-600">
        <span class="font-bold">Price:</span>
        <%= Cldr.format_price(@property.price) %> / <%= format_taxed_price(@property.price) %> (after taxes)
      </p>
      <p class="text-gray-600">
        <span class="font-bold">Description:</span>
        <%= if @property.description == "" do %>
          No description provided.
        <% else %>
          <%= @property.description %>
        <% end %>
      </p>
      <div class="flex gap-4">
        <abbr title="Manage Tenants">
          <.button phx-click={open_manage_tenants_modal(@property.id)} disabled={@tenant_count == 0}>
            <.icon name="hero-user" class="w-4 h-4" />
          </.button>
        </abbr>
        <%= if @property.has_agreement  do %>
          <.link navigate={"/properties/#{@property.id}/view_agreement"}>
            <abbr title="View Agreement">
              <.button>
                <.icon name="hero-clipboard" class="w-4 h-4" />
              </.button>
            </abbr>
          </.link>
        <% else %>
          <.link navigate={"/properties/#{@property.id}/agreement"}>
            <abbr title="Generate Agreement">
              <.button>
                <.icon name="hero-clipboard" class="w-4 h-4" />
              </.button>
            </abbr>
          </.link>
        <% end %>
        <.link navigate={"/properties/#{@property.id}/expenses"}>
          <abbr title="Manage Expenses">
            <.button>
              <.icon name="hero-banknotes" class="w-4 h-4" />
            </.button>
          </abbr>
        </.link>
        <.link navigate={"/properties/#{@property.id}"}>
          <abbr title="Edit Property">
            <.button>
              <.icon name="hero-pencil" class="w-4 h-4" />
            </.button>
          </abbr>
        </.link>
      </div>

      <div class="flex gap-4"></div>
    </div>
    """
  end

  defp open_manage_tenants_modal(property_id) do
    show_modal(JS.push("manage_tenants", value: %{"id" => property_id}), "manage-tenants-modal")
  end

  defp format_taxed_price(price) do
    with {:ok, taxed_price} <- Property.get_taxed_price(price) do
      Cldr.format_price(taxed_price)
    end
  end
end
