defmodule TenanteeWeb.HomeLive do
  alias Tenantee.Entity.{Rent, Property, Tenant}
  alias Tenantee.Config
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, default(socket)}
  end

  def render(assigns) do
    ~H"""
    <%= if is_nil(@name) do %>
      <.modal id="initial-modal" show>
        <p class="text-3xl font-bold">Hey there!</p>
        <p class="text-gray-600">First time here? Let's get you started.</p>
        <p class="mt-3 text-gray-600">
          Please proceed to the
          <a class="text-green-500 hover:text-green-700 transition-colors" href={~p"/settings"}>
            configuration page
          </a>
          to set up your instance.
        </p>
      </.modal>
      <h1 class="text-3xl font-bold">Welcome to Tenantee!</h1>
      <p class="text-gray-600">Looks like you haven't set up your instance yet.</p>
      <p class="mt-3 text-gray-600">
        Please proceed to the
        <a class="text-green-500 hover:text-green-700 transition-colors" href={~p"/settings"}>
          configuration page
        </a>
        to set up your instance.
      </p>
    <% else %>
      <h1 class="text-3xl font-bold">Hey there, <%= @name %>.</h1>
      <p class="text-gray-600">Thank you for trying out Tenantee!</p>
      <hr class="my-5" />
      <%= if @property_count == 0 do %>
        <p class="text-gray-600">Looks like you haven't added any properties yet.</p>
        <p class="mt-3 text-gray-600">
          Why don't you head over to the
          <a class="text-green-500 hover:text-green-700 transition-colors" href={~p"/properties"}>
            properties page
          </a>
          and add your first property?
        </p>
      <% else %>
        <p class="text-gray-600">
          Looks, like you own <%= @property_count %> <%= if @property_count == 1,
            do: "property",
            else: "properties" %> and <%= @tenant_count %> <%= if @tenant_count == 1,
            do: "tenant",
            else: "tenants" %>.
        </p>
        <p class="text-gray-600">
          You can manage them from the
          <a class="text-green-500 hover:text-green-700 transition-colors" href={~p"/properties"}>
            properties page
          </a>
          or the <a class="text-green-500 hover:text-green-700 transition-colors" href={~p"/tenants"}>
          tenants page
        </a>.
        </p>
      <% end %>

      <%= if @unpaid > 0 or @overdue > 0 do %>
        <p class="mt-3 text-gray-600">
          You have <%= @unpaid %> unpaid and <%= @overdue %> overdue <%= if @overdue == 1,
            do: "rent",
            else: "rents" %>.
        </p>

        <a class="text-green-500 hover:text-green-700 transition-colors" href={~p"/tenants"}>
          View your rents here
        </a>
      <% end %>
    <% end %>
    """
  end

  defp default(socket) do
    case Config.get(:name, nil) do
      nil ->
        assign(socket, name: nil, property_count: 0, tenant_count: 0, unpaid: 0, overdue: 0)

      name ->
        assign(socket,
          name: name,
          property_count: Property.count(),
          tenant_count: Tenant.count(),
          unpaid: Rent.total_unpaid(),
          overdue: Rent.total_overdue()
        )
    end
  end
end
