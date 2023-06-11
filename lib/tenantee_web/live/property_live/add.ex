defmodule TenanteeWeb.PropertyLive.Add do
  alias Tenantee.Config
  alias Tenantee.Entity.Property
  alias TenanteeWeb.PropertyLive.Helper
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, Helper.default(socket)}
  end

  def handle_event("change", %{"_target" => [target]} = params, socket) do
    value = params[target]
    {:noreply, assign(socket, String.to_existing_atom(target), value) |> assign(:created, false)}
  end

  def handle_event(
        "create",
        %{"name" => name, "description" => description, "address" => address, "price" => price},
        socket
      ) do
    with {:ok, currency} <- Config.get(:currency),
         {:ok, _property} <-
           Property.create(%{
             name: name,
             description: description,
             address: address,
             price: Money.new(price, currency)
           }) do
      {:noreply,
       assign(socket, :created, true) |> put_flash(:info, "#{name} was created successfully.")}
    else
      {:error, "key not found"} ->
        {:noreply, put_flash(socket, :error, "Please set your default currency in the settings.")}

      {:error, _reason} ->
        {:noreply, put_flash(socket, :error, "Error creating the property.")}
    end
  end

  def render(assigns) do
    assigns = assign(assigns, :disabled, Helper.is_submit_disabled?(assigns))

    ~H"""
    <a class="text-gray-500" href={~p"/properties"}>
      <.icon name="hero-arrow-left" /> Back to properties
    </a>
    <h1 class="text-3xl font-bold my-4">Create new property</h1>
    <form phx-submit="create" class="flex flex-col gap-4 max-w-xs">
      <.input
        phx-change="change"
        type="text"
        name="name"
        value={@name}
        label="Name"
        placeholder="Name of the property"
        required
      />
      <.input
        phx-change="change"
        type="text"
        name="address"
        value={@address}
        label="Address"
        placeholder="Address of the property"
        required
      />
      <.input
        phx-change="change"
        type="number"
        name="price"
        min="0"
        step="0.1"
        value={@price}
        label="Price"
        placeholder="Price of the property"
        required
      />
      <.input
        phx-change="change"
        type="textarea"
        name="description"
        value={@description}
        label="Description"
        placeholder="Description of the property"
      />

      <.button type="submit" disabled={@disabled or @created} phx-disable-with="Creating...">
        Create
      </.button>
    </form>
    """
  end
end
