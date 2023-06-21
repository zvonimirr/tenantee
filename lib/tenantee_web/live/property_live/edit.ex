defmodule TenanteeWeb.PropertyLive.Edit do
  alias TenanteeWeb.PropertyLive.Helper
  alias Tenantee.Config
  alias Tenantee.Entity.Property
  use TenanteeWeb, :live_view

  def mount(params, _session, socket) do
    {:ok, Helper.default(socket, params)}
  end

  def handle_event(
        "update",
        %{"name" => name, "description" => description, "address" => address, "price" => price},
        socket
      ) do
    with {:ok, currency} <- Config.get(:currency),
         :ok <-
           Property.update(socket.assigns.id, %{
             name: name,
             description: description,
             address: address,
             price: Helper.handle_price(price, currency)
           }),
         {:ok, property} <- Property.get(socket.assigns.id) do
      {:noreply, handle_success(socket, name, property)}
    else
      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Something went wrong, please try again.")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, Helper.is_submit_disabled?(assigns))

    ~H"""
    <.link class="text-gray-500" navigate={~p"/properties"}>
      <.icon name="hero-arrow-left" /> Back to properties
    </.link>
    <h1 class="text-3xl font-bold my-4">Edit <%= @name %></h1>
    <form
      id="property-edit-form"
      phx-hook="FormHook"
      phx-submit="update"
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

      <.button type="submit" disabled={@disabled} phx-disable-with="Updating...">
        Update
      </.button>
    </form>
    """
  end

  def handle_success(socket, name, property) do
    socket
    |> assign(:name, property.name)
    |> assign(:address, property.address)
    |> assign(:price, property.price.amount |> to_string())
    |> assign(:description, property.description)
    |> put_flash(:info, "#{name} was updated successfully.")
  end
end
