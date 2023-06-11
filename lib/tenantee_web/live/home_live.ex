defmodule TenanteeWeb.HomeLive do
  alias Tenantee.Config
  use TenanteeWeb, :live_view

  def mount(_params, _session, socket) do
    with value <- Config.get(:name) do
      {:ok, assign(socket, :name, value)}
    end
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
    <% end %>
    """
  end
end
