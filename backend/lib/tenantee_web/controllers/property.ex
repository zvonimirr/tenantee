defmodule TenanteeWeb.PropertyController do
  use TenanteeWeb, :controller
  use TenanteeWeb.Swagger.Property
  alias Tenantee.Property
  alias Tenantee.Rent
  alias Tenantee.Utils.Currency
  import Tenantee.Utils.Error, only: [respond: 3]

  def add(
        conn,
        %{
          "name" => _name,
          "location" => _location,
          "price" => price
        } = params
      )
      when is_number(price) and price > 0 do
    with currency <- Map.get(params, "currency", "USD"),
         :ok <- Currency.valid?(currency),
         money <- Money.new(price, currency),
         property_params <- Map.replace(params, "price", money),
         {:ok, property} <-
           Property.create_property(property_params) do
      conn
      |> put_status(:created)
      |> render("show.json", %{property: property})
    else
      {:error, "Invalid currency"} ->
        respond(conn, :unprocessable_entity, "Invalid currency")
    end
  end

  def add(conn, _) do
    respond(conn, :unprocessable_entity, "Invalid property")
  end

  def find(conn, %{"id" => id}) do
    case Property.get_property(id) do
      {:ok, property} ->
        conn
        |> render("show.json", %{property: property})

      {:error, :not_found} ->
        respond(conn, :not_found, "Property not found")
    end
  end

  def list(conn, _) do
    with properties <- Property.get_all_properties() do
      render(conn, "show.json", %{properties: properties})
    end
  end

  def update(
        conn,
        %{
          "id" => id
        } = params
      ) do
    with true <- Map.keys(params) -- ["id"] != [],
         currency <- Map.get(params, "currency", "USD"),
         :ok <- Currency.valid?(currency),
         property_params <-
           Map.replace_lazy(params, "price", fn price -> Money.new(price, currency) end)
           |> Map.delete("id"),
         {:ok, _property} <- Property.get_property(id),
         {:ok, updated_property} <- Property.update_property(id, property_params) do
      render(conn, "show.json", %{property: updated_property})
    else
      {:error, "Invalid currency"} ->
        respond(conn, :unprocessable_entity, "Invalid currency")

      {:error, :not_found} ->
        respond(conn, :not_found, "Property not found")

      false ->
        respond(conn, :unprocessable_entity, "Invalid property")
    end
  end

  def delete_by_id(conn, %{"id" => id}) do
    case Property.delete_property(id) do
      {:ok, :deleted} -> respond(conn, :no_content, "Property deleted")
      {:error, :not_found} -> respond(conn, :not_found, "Property not found")
    end
  end

  def add_tenant(conn, %{"id" => id, "tenant" => tenant_id}) do
    case Property.add_tenant(id, tenant_id) do
      {:ok, property} ->
        conn
        |> put_status(:created)
        |> render("show.json", %{property: property})

      {:error, _error} ->
        respond(conn, :not_found, "Property or tenant not found")
    end
  end

  def remove_tenant(conn, %{"id" => id, "tenant" => tenant_id}) do
    case Property.remove_tenant(id, tenant_id) do
      {:ok, property} ->
        conn
        |> put_status(:no_content)
        |> render("show.json", %{property: property})

      {:error, _error} ->
        respond(conn, :not_found, "Property or tenant not found")
    end
  end

  def unpaid_rents(conn, %{"id" => id}) do
    with {:ok, property} <- Property.get_property(id),
         rents <- Rent.get_unpaid_rents_by_property_id(property.id) do
      render(conn, "show_rent.json", %{rents: rents})
    else
      {:error, :not_found} -> respond(conn, :not_found, "Property not found")
    end
  end
end
