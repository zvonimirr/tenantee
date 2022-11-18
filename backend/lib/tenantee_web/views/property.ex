defmodule TenanteeWeb.PropertyView do
  use TenanteeWeb, :view

  def render("show.json", %{properties: properties}) do
    IO.inspect(properties)

    %{
      properties:
        Enum.map(properties, fn property ->
          render("show.json", %{property: property}) |> Map.get(:property)
        end)
    }
  end

  def render("show.json", %{property: property}) do
    %{
      property: %{
        id: property.id,
        name: property.name,
        description: property.description,
        location: property.location,
        price: property.price,
        currency: property.currency,
        inserted_at: property.inserted_at,
        updated_at: property.updated_at
      }
    }
  end

  def render("error.json", %{message: message}) do
    %{error: message}
  end
end
