defmodule TenanteeWeb.ConfigLive do
  alias Tenantee.Entity.{Property, Tenant}
  alias Tenantee.Cldr
  alias Tenantee.Config
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    with name <- Config.get(:name, ""),
         currency <- Config.get(:currency, ""),
         tax <- Config.get(:tax, 0),
         property_count <- Property.count(),
         tenant_count <- Tenant.count() do
      {:ok,
       assign_values(socket, %{name: name, currency: currency, tax: tax})
       |> assign(:count, property_count + tenant_count)}
    end
  end

  def handle_event("save", %{"name" => name, "currency" => currency, "tax" => tax}, socket) do
    with :ok <- Config.set(:name, name),
         :ok <- Config.set(:currency, currency),
         :ok <- Config.set(:tax, tax) do
      {:noreply,
       assign_values(socket, %{name: name, currency: currency, tax: tax})
       |> put_flash(:info, "Configuration saved successfully!")}
    else
      :error ->
        {:noreply,
         assign_values(socket, %{name: name, currency: currency, tax: tax})
         |> put_flash(:error, "Failed to save the configuration!")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, disabled?(assigns))

    ~H"""
    <h1 class="text-3xl font-bold">Configuration</h1>
    <form id="config-form" phx-hook="FormHook" phx-submit="save" class="flex flex-col gap-4 max-w-xs">
      <.input name="name" value={@name} label="Name" maxlength="255" placeholder="Your name..." />
      <.input
        name="tax"
        value={@tax}
        label="Tax percentage (%)"
        type="number"
        min="0.1"
        step="0.1"
        placeholder="Tax percentage..."
      />
      <.input
        type="select"
        name="currency"
        value={@currency}
        options={get_options()}
        disabled={@count > 0}
        label="Currency"
        prompt="Your currency..."
      />
      <%= if @count > 0 do %>
        <div>
          <p class="text-sm text-gray-500">
            You can't change the currency because you already have properties and/or tenants.
          </p>
          <p class="text-sm text-gray-500">
            If you want to change the currency, you need to delete all your properties and tenants first.
          </p>
          <.input type="hidden" name="currency" value={@currency} />
        </div>
      <% end %>
      <.button type="submit" disabled={@disabled} phx-disable-with="Saving...">
        Save
      </.button>
    </form>
    """
  end

  defp assign_values(socket, %{name: name, currency: currency, tax: tax}) do
    assign(socket, :name, name)
    |> assign(:currency, currency)
    |> assign(:tax, tax)
  end

  defp disabled?(assigns) do
    [
      assigns.name,
      assigns.currency
    ]
    |> Enum.any?(&(String.length(&1) == 0)) or assigns.tax <= 0
  end

  defp get_options() do
    Money.Currency.known_current_currencies()
    |> Enum.map(&{currency_to_name(&1), &1})
  end

  defp currency_to_name(currency) do
    with {:ok, "1 " <> name} <- Cldr.Number.to_string(1, format: :long, currency: currency) do
      name |> String.capitalize()
    end
  end
end
