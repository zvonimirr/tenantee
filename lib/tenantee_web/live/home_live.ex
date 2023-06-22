defmodule TenanteeWeb.HomeLive do
  alias Tenantee.Cldr
  alias Tenantee.Entity.{Rent, Property, Tenant}
  alias Tenantee.Config
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, default(socket)}
  end

  def render(assigns) do
    ~H"""
    <%= if Config.lacks_config?() do %>
      <.modal id="initial-modal" show>
        <p class="text-3xl font-bold">Hey there!</p>
        <p class="text-gray-600">First time here? Let's get you started.</p>
        <p class="mt-3 text-gray-600">
          Please proceed to the
          <.link
            class="text-green-500 hover:text-green-700 transition-colors"
            navigate={~p"/settings"}
          >
            configuration page
          </.link>
          to set up your instance.
        </p>
      </.modal>
      <h1 class="text-3xl font-bold">Welcome to Tenantee!</h1>
      <p class="text-gray-600">Looks like you haven't set up your instance yet.</p>
      <p class="mt-3 text-gray-600">
        Please proceed to the
        <.link class="text-green-500 hover:text-green-700 transition-colors" navigate={~p"/settings"}>
          configuration page
        </.link>
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
          <.link
            class="text-green-500 hover:text-green-700 transition-colors"
            navigate={~p"/properties"}
          >
            properties page
          </.link>
          and add your first property?
        </p>
      <% else %>
        <p class="text-gray-600">
          Looks like you own <%= @property_count %> <%= if @property_count == 1,
            do: "property",
            else: "properties" %> and <%= @tenant_count %> <%= if @tenant_count == 1,
            do: "tenant",
            else: "tenants" %>.
        </p>
        <p class="text-gray-600">
          You can manage them from the
          <.link
            class="text-green-500 hover:text-green-700 transition-colors"
            navigate={~p"/properties"}
          >
            properties page
          </.link>
          or the <.link
            class="text-green-500 hover:text-green-700 transition-colors"
            navigate={~p"/tenants"}
          >
          tenants page
        </.link>.
        </p>
        <hr class="my-5" />
        <p class="text-xl">Monthly balance:</p>
        <p class="text-gray-600">
          <%= if @income == :error do %>
            You have not set up your currency yet.
          <% else %>
            You have made <%= @income %> this month.
          <% end %>
        </p>
      <% end %>

      <%= if @unpaid > 0 or @overdue > 0 do %>
        <hr class="my-5" />
        <p class="text-xl">Unpaid rents:</p>
        <p class="text-gray-600">
          You have <%= @unpaid %> unpaid and <%= @overdue %> overdue <%= if @overdue == 1,
            do: "rent",
            else: "rents" %>.
        </p>

        <.link class="text-green-500 hover:text-green-700 transition-colors" navigate={~p"/tenants"}>
          View your tenants here
        </.link>
      <% end %>
    <% end %>
    """
  end

  defp default(socket) do
    income =
      case Rent.get_income() do
        {:ok, income} -> format_price(income)
        {:error, _} -> :error
      end

    assign(socket,
      name: Config.get(:name, nil),
      property_count: Property.count(),
      tenant_count: Tenant.count(),
      unpaid: Rent.total_unpaid(),
      overdue: Rent.total_overdue(),
      income: income
    )
  end

  defp format_price(price) do
    with {:ok, formatted_price} <- Cldr.Money.to_string(price, symbol: true) do
      formatted_price
    end
  end
end
