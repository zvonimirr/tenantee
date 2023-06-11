defmodule TenanteeWeb.ConfigLive do
  alias Tenantee.Cldr
  alias Tenantee.Config
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    with name <- Config.get(:name, ""),
         currency <- Config.get(:currency, "") do
      {:ok, assign(socket, name: name) |> assign(:currency, currency)}
    end
  end

  def handle_event("change", %{"_target" => [target]} = params, socket) do
    value = params[target]
    {:noreply, assign(socket, String.to_existing_atom(target), value)}
  end

  def handle_event("save", %{"name" => name, "currency" => currency}, socket) do
    with :ok <- Config.set(:name, name),
         :ok <- Config.set(:currency, currency) do
      {:noreply, put_flash(socket, :info, "Configuration saved successfully!")}
    else
      :error ->
        {:noreply, put_flash(socket, :error, "Failed to save the configuration!")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, is_disabled(assigns))

    ~H"""
    <h1 class="text-3xl font-bold">Configuration</h1>
    <form phx-submit="save" class="flex flex-col gap-4 max-w-xs">
      <.input phx-change="change" name="name" value={@name} label="Name" placeholder="Your name..." />
      <.input
        phx-change="change"
        type="select"
        name="currency"
        value={@currency}
        options={get_options()}
        label="Currency"
        prompt="Your currency..."
      />
      <.button type="submit" disabled={@disabled} phx-disable-with="Saving...">
        Save
      </.button>
    </form>
    """
  end

  defp is_disabled(assigns) do
    [
      assigns.name,
      assigns.currency
    ]
    |> Enum.any?(&(String.length(&1) == 0))
  end

  defp get_options() do
    Money.Currency.known_current_currencies()
    |> Enum.map(&{currency_to_name(&1), &1})
  end

  defp currency_to_name(currency) do
    with {:ok, "1 " <> name} <- Cldr.Number.to_string(1, format: :long, currency: currency) do
      name |> String.capitalize()
    else
      _ -> currency
    end
  end
end
