defmodule TenanteeWeb.PropertyController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Property
  alias Tenantee.Property
  alias Tenantee.Rent

  def add(conn, %{
        "property" =>
          %{
            "name" => _name,
            "location" => _location,
            "price" => price
          } = params
      })
      when is_integer(price) do
    with currency <- Map.get(params, "currency", "USD"),
         true <- Money.Currency.exists?(currency),
         property_params <- Map.replace(params, "price", Money.new(price, currency)),
         {:ok, property} <-
           Property.create_property(property_params) do
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

  def find(conn, %{"id" => id}) do
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

  def list(conn, _) do
    with properties <- Property.get_all_properties() do
      render(conn, "show.json", %{properties: properties})
    end
  end

  def update(conn, %{
        "id" => id,
        "property" => params
      }) do
    with currency <- Map.get(params, "currency", "USD"),
         true <- Money.Currency.exists?(currency),
         property_params <-
           Map.replace_lazy(params, "price", fn price -> Money.new(price, currency) end),
         property <- Property.get_property(id) do
      if property do
        with {:ok, updated_property} <- Property.update_property(id, property_params) do
          render(conn, "show.json", %{property: updated_property})
        end
      else
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Property not found"})
      end
    end
  end

  def update(conn, _) do
    conn
    |> put_status(:bad_request)
    |> render("error.json", %{message: "Invalid params"})
  end

  def delete_by_id(conn, %{"id" => id}) do
    with {affected_rows, nil} <- Property.delete_property(id) do
      if affected_rows < 1 do
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Property not found"})
      else
        conn
        |> put_status(:no_content)
        |> render("delete.json", %{})
      end
    end
  end

  def add_tenant(conn, %{"id" => id, "tenant" => tenant_id}) do
    with {:ok, property} <- Property.add_tenant(id, tenant_id) do
      render(conn, "show.json", %{property: property})
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Property or tenant not found"})
    end
  end

  def remove_tenant(conn, %{"id" => id, "tenant" => tenant_id}) do
    with {:ok, property} <- Property.remove_tenant(id, tenant_id) do
      conn
      |> put_status(:no_content)
      |> render("show.json", %{property: property})
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Property or tenant not found"})
    end
  end

  def unpaid_rents(conn, %{"id" => id}) do
    with property <- Property.get_property(id),
         false <- is_nil(property),
         rents <- Rent.get_unpaid_rents_by_property_id(property.id) do
      render(conn, "show_rent.json", %{rents: rents})
    else
      _ ->
        conn
        |> put_status(:not_found)
        |> render("error.json", %{message: "Property not found"})
    end
  end
end
