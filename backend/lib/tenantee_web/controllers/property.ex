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
      conn
      |> put_status(:created)
      |> render("show.json", %{property: property})
    end
  end

  def add(conn, _) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
  end

  def get(conn, %{"id" => id}) do
    with property <- Property.get_property(id) do
      if property do
        render(conn, "show.json", %{property: property})
      else
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Property not found"})
      end
    end
  end

  def get(conn, _) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
  end

  def list(conn, _) do
    with properties <- Property.get_all_properties() do
      render(conn, "show.json", %{properties: properties})
    end
  end

  def update(conn, %{
        "id" => id,
        "property" => params
      }) do
    with {:ok, property} <- Property.update_property(id, params) do
      render(conn, "show.json", %{property: property})
    end
  end

  def update(conn, _) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
  end

  def delete(conn, %{"id" => id}) do
    with {affected_rows, nil} <- Property.delete_property(id) do
      if affected_rows < 1 do
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Property not found"})
      else
        render(conn, "delete.json", %{affected_rows: affected_rows})
      end
    end
  end
end
