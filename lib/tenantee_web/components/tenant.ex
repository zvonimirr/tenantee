defmodule TenanteeWeb.Components.Tenant do
  @moduledoc """
  Provides UI components for the Tenant context.
  """
  alias Tenantee.Entity.Rent
  use Phoenix.Component
  import TenanteeWeb.CoreComponents

  @doc """
  Renders a tenant card.
  """
  attr :tenant, :map, required: true

  def card(assigns) do
    assigns = assign(assigns, :count, length(assigns.tenant.properties))
    assigns = assign(assigns, :unpaid_rents, Rent.total_unpaid(assigns.tenant.id))
    assigns = assign(assigns, :overdue_rents, Rent.total_overdue(assigns.tenant.id))

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
      <p class="text-gray-600">
        <abbr title={get_properties_names(@tenant)}>
          Currently occupying <%= @count %> <%= if @count == 1, do: "property", else: "properties" %>.
        </abbr>
      </p>
      <%= if @count > 0 do %>
        <div>
          <p class={[
            @unpaid_rents > 0 && "text-yellow-500",
            @unpaid_rents == 0 && "text-green-500"
          ]}>
            Has <%= @unpaid_rents %> unpaid <%= if @unpaid_rents == 1, do: "rent", else: "rents" %>.
          </p>
          <%= if @overdue_rents > 0 do %>
            <p class="text-red-500">
              <%= @overdue_rents %> of them <%= if @overdue_rents == 1, do: "is", else: "are" %> overdue.
            </p>
          <% else %>
            <p class="text-yellow-500">
              But, none of them are overdue.
            </p>
          <% end %>
        </div>
      <% else %>
        <div>
          <p class="text-gray-600">
            Since this tenant is not occupying
            any property, it has no unpaid rents.
          </p>
        </div>
      <% end %>
      <a href={"/tenants/#{@tenant.id}"}>
        <.button>
          <.icon name="hero-pencil" class="w-4 h-4" /> Edit
        </.button>
      </a>
    </div>
    """
  end

  @doc """
  Renders a tenant list item.
  """
  attr :tenant, :map, required: true
  attr :property, :map, required: true

  def list_item(assigns) do
    ~H"""
    <div class={[
      "flex items-center gap-2 shadow-lg border border-gray-200 rounded-lg p-4 text-black font-semibold",
      is_tenant_in_property?(@tenant, @property) && "bg-green-300"
    ]}>
      <.input
        type="checkbox"
        name={"lease_#{@property.id}_#{@tenant.id}"}
        value={is_tenant_in_property?(@tenant, @property)}
        phx-click="toggle_lease"
        phx-value-property={@property.id}
        phx-value-tenant={@tenant.id}
      />
      <p>
        <%= @tenant.first_name %> <%= @tenant.last_name %>
      </p>
    </div>
    """
  end

  defp is_tenant_in_property?(tenant, property) do
    property.tenants
    |> Enum.map(& &1.id)
    |> Enum.member?(tenant.id)
  end

  defp get_properties_names(tenant) do
    case Enum.map(tenant.properties, &(&1.name <> " at " <> &1.address))
         |> Enum.join(", ") do
      "" -> "No properties"
      names -> names
    end
  end
end
