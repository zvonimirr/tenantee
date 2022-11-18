defmodule TenanteeWeb.HealthCheckView do
  use TenanteeWeb, :view

  def render("index.json", %{message: message}) do
    %{message: message}
  end
end
