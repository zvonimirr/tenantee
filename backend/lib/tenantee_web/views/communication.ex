defmodule TenanteeWeb.CommunicationView do
  use TenanteeWeb, :view

  def render("show.json", %{communications: communications}) do
    %{
      communications: Enum.map(communications, &render("show.json", %{communication: &1}))
    }
  end

  def render("show.json", %{communication: communication}) do
    %{
      id: communication.id,
      type: communication.type,
      value: communication.value
    }
  end
end
