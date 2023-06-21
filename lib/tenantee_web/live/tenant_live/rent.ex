defmodule TenanteeWeb.TenantLive.Rent do
  alias Tenantee.Entity.{Rent, Tenant, Property}
  alias TenanteeWeb.TenantLive.Helper
  import TenanteeWeb.Components.Rent, only: [list_item: 1]
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, Helper.default(socket, params)}
  end

  def handle_event("pay", %{"rent" => rent_id}, socket) do
    with {:ok, _rent} <- Rent.pay(rent_id),
         {:ok, tenant} <- Tenant.get(socket.assigns.id) do
      {:noreply,
       Helper.default(socket, %{"id" => tenant.id})
       |> put_flash(:info, "Rent paid successfully")
       |> push_event("phx:enable", %{id: "rent_#{rent_id}"})}
    else
      _error ->
        {:noreply,
         put_flash(socket, :error, "Something went wrong.")
         |> push_event("phx:enable", %{id: "rent_#{rent_id}"})}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :rent_groups, group_rents(assigns.rents))

    ~H"""
    <.link class="text-gray-500" navigate={~p"/tenants"}>
      <.icon name="hero-arrow-left" /> Back to tenants
    </.link>
    <h1 class="text-2xl font-semibold">Rents for <%= @first_name %> <%= @last_name %></h1>
    <%= if @rents == [] do %>
      <p class="text-gray-500">No rents found.</p>
    <% else %>
      <p class="text-gray-500">
        Rents are grouped by property.
      </p>
      <p class="text-gray-500">
        If they have multiple rents for the same property, they will be grouped together.
      </p>
      <p class="text-gray-500">
        You can click on the name of the property to collapse or expand the rents for that property.
      </p>
      <ul class="mt-4 space-y-4" id="rent-groups-container" phx-hook="ModalHook">
        <%= for group <- @rent_groups do %>
          <details class="border rounded-lg p-4 cursor-pointer" open>
            <summary
              class="flex flex-col"
              data-tooltip={
                case get_group_status(group) do
                  :overdue -> "Overdue"
                  :unpaid -> "Unpaid"
                  _ -> nil
                end
              }
            >
              <h2 class="text-2xl font-semibold">
                <div class="flex items-center gap-2">
                  <%= if not is_nil(get_group_status(group)) do %>
                    <.icon
                      name="hero-exclamation-triangle"
                      class={
                        "w-8 h-8 #{get_group_status(group) == :overdue && "text-red-500"} #{get_group_status(group) == :unpaid && "text-yellow-500"}"
                      }
                    />
                  <% end %>
                  <span><%= group.property.name %></span>
                </div>
              </h2>
              <span class="text-gray-500"><%= group.property.address %></span>
            </summary>

            <ul class="mt-4 space-y-4 p-4 border rounded-lg">
              <%= for rent <- group.rents do %>
                <.list_item rent={rent} />
              <% end %>
            </ul>
          </details>
        <% end %>
      </ul>
    <% end %>
    """
  end

  defp group_rents(rents) do
    rents
    |> Enum.group_by(& &1.property_id)
    |> Enum.map(fn {property_id, rents} ->
      {:ok, property} = Property.get(property_id)

      %{property: property, rents: rents}
    end)
  end

  defp has_unpaid_rent?(rents) do
    Enum.any?(rents, fn rent -> not rent.paid end)
  end

  defp has_overdue_rent?(rents) do
    Enum.any?(rents, fn rent ->
      rent.due_date < Date.utc_today() and not rent.paid
    end)
  end

  defp get_group_status(rent_group) do
    case [has_overdue_rent?(rent_group.rents), has_unpaid_rent?(rent_group.rents)] do
      [true, _] -> :overdue
      [_, true] -> :unpaid
      _ -> nil
    end
  end
end
