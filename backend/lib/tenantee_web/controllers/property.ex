defmodule TenanteeWeb.PropertyController do
  use TenanteeWeb, :controller
  alias Tenantee.Property

  def add(conn, %{
        "property" =>
          %{
            "name" => _name,
            "location" => _location,
            "price" => price,
            "currency" => _currency
          } = params
      })
      when is_number(price) do
    with {:ok, property} <- Property.create_property(params) do
      render(conn, "show.json", %{property: property})
    end
  end

  def add(conn, _) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
  end
end
