defmodule TenanteeWeb.PropertyLive.List do
  alias Tenantee.Entity.Property
  use TenanteeWeb, :live_view
  import TenanteeWeb.Components.Property, only: [card: 1]

  def mount(_params, _session, socket) do
    {:ok, assign(socket, properties: Property.all(), property: nil)}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Property.get(id) do
      {:ok, property} ->
        {:noreply, assign(socket, property: property)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Property not found")}
    end
  end

  def handle_event("do_delete", %{"id" => id}, socket) do
    case Property.delete(id) do
      :ok ->
        {:noreply,
         assign(socket, properties: Property.all(), property: nil)
         |> put_flash(:info, "Property deleted successfully")}

      _error ->
        {:noreply, put_flash(socket, :error, "Property not found")}
    end
  end

  def render(assigns) do
    ~H"""
    <%= if @property do %>
      <.modal id="confirm-modal" show>
        <p class="text-2xl mb-4 font-bold">Are you sure?</p>
        <p class="text-gray-500">This action cannot be undone.</p>
        <p class="text-gray-500"><%= @property.name %> will be gone forever.</p>
        <p class="text-gray-500 mb-4">
          This will also delete all the tenants and leases associated with this property.
        </p>
        <div class="flex justify-end gap-4">
          <.button
            phx-click="do_delete"
            phx-value-id={@property.id}
            class="ml-2 bg-red-500 hover:bg-red-600"
          >
            Delete
          </.button>
          <.button>Cancel</.button>
        </div>
      </.modal>
    <% end %>
    <h1 class="text-3xl font-bold mb-4">Manage your properties</h1>
    <%= if @properties == [] do %>
      <p class="text-gray-500 mb-4">You don't have any properties yet.</p>
      <a href={~p"/properties/new"}>
        <.button>Why not add one?</.button>
      </a>
    <% else %>
      <div class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        <%= for property <- @properties do %>
          <.card property={property} />
        <% end %>
      </div>
      <a href={~p"/properties/new"}>
        <.button class="mt-4">
          <.icon name="hero-home" /> Add another property
        </.button>
      </a>
    <% end %>
    """
  end
end
