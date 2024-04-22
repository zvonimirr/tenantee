defmodule TenanteeWeb.PropertyLive.Add do
  alias Tenantee.Config
  alias Tenantee.Entity.Property
  alias TenanteeWeb.PropertyLive.Helper
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, Helper.default(socket)}
  end

  def handle_event(
        "create",
        %{"name" => name, "description" => description, "address" => address, "price" => price},
        socket
      ) do
    with {:ok, currency} <- Config.get(:currency),
         {:ok, property} <-
           Property.create(%{
             name: name,
             description: description,
             address: address,
             price: Helper.handle_price(price, currency)
           }) do
      {:noreply, handle_success(socket, property.id, name)}
    else
      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Something went wrong, please try again.")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, Helper.submit_disabled?(assigns))

    ~H"""
    <.link class="text-gray-500" navigate={~p"/properties"}>
      <.icon name="hero-arrow-left" /> Back to properties
    </.link>
    <h1 class="text-3xl font-bold my-4">Create new property</h1>
    <form
      id="property-add-form"
      phx-hook="FormHook"
      phx-submit="create"
      class="flex flex-col gap-4 max-w-xs"
    >
      <.input
        type="text"
        name="name"
        value={@name}
        label="Name"
        placeholder="Name of the property"
        maxlength="255"
        required
      />
      <.input
        type="text"
        name="address"
        value={@address}
        label="Address"
        placeholder="Address of the property"
        maxlength="255"
        required
      />
      <.input
        type="number"
        name="price"
        min="0.1"
        max="9999999999.9"
        step="0.1"
        value={@price}
        label={"Price (" <> @currency <> ")"}
        placeholder="Price of the property"
        required
      />
      <.input
        type="textarea"
        name="description"
        value={@description}
        label="Description"
        maxlength="255"
        placeholder="Description of the property"
      />

      <.button type="submit" disabled={@disabled or @created} phx-disable-with="Creating...">
        Create
      </.button>
    </form>
    """
  end

  def handle_success(socket, id, name) do
    put_flash(socket, :info, "#{name} was created successfully.")
    |> push_navigate(to: ~p"/properties/#{id}")
  end
end
