defmodule Tenantee.Rent.Worker do
  use Oban.Worker, queue: :rents
  alias Tenantee.Property
  alias Tenantee.Rent

  @impl Oban.Worker
  def perform(%Oban.Job{}) do
    Property.get_all_properties()
    |> Enum.each(fn property ->
      property.tenants
      |> Enum.each(fn tenant ->
        Rent.add_rent(
          property,
          tenant,
          DateTime.utc_now() |> DateTime.add(5 * 24 * 60 * 60, :second)
        )
      end)
    end)
  end
end