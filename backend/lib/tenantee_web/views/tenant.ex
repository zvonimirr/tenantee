defmodule TenanteeWeb.TenantView do
  use TenanteeWeb, :view

  def render("show.json", %{tenants: tenants}) do
    %{
      tenants:
        Enum.map(tenants, fn tenant ->
          render("show.json", %{tenant: tenant}) |> Map.get(:tenant)
        end)
    }
  end

  def render("show.json", %{tenant: tenant}) do
    %{
      tenant: %{
        id: tenant.id,
        name: tenant.first_name <> " " <> tenant.last_name,
        phone: tenant.phone,
        email: tenant.email,
        created_at: tenant.inserted_at,
        updated_at: tenant.updated_at
      }
    }
  end

  def render("delete.json", %{}) do
    %{
      message: "Tenant deleted"
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
