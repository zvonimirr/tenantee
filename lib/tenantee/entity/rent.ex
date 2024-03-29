defmodule Tenantee.Entity.Rent do
  @moduledoc """
  Helper functions for rents.
  """
  alias Tenantee.Config
  alias Tenantee.Schema.Rent, as: Schema
  alias Tenantee.Entity.{Tenant, Property}
  alias Tenantee.Repo
  import Ecto.Query, only: [from: 2]

  @doc """
  Gets all rents that were paid this month, sums them up and returns the total (after tax).
  """
  @spec get_income() :: {:ok, Money.t()} | {:error, String.t()}
  def get_income() do
    currency = Config.get(:currency, nil)

    start_date = Date.utc_today() |> Date.beginning_of_month()
    end_date = Date.utc_today() |> Date.end_of_month()

    income =
      from(r in Schema,
        select: fragment("SUM(amount)"),
        where:
          fragment("? BETWEEN ? AND ?", r.due_date, ^start_date, ^end_date) and r.paid == true
      )
      |> Repo.one()

    get_taxed_price(income, currency)
  end

  @doc """
  Gets a rent by id.
  """
  @spec get(integer()) :: {:ok, Schema.t()} | {:error, String.t()}
  def get(id) do
    case Repo.get(Schema, id) do
      nil -> {:error, "Rent not found"}
      rent -> {:ok, rent}
    end
  end

  @doc """
  Creates a new rent.
  """
  @spec create(integer(), integer()) ::
          {:ok, Schema.t()} | {:error, Ecto.Changeset.t() | String.t()}
  def create(tenant_id, property_id) do
    with {:ok, tenant} <- Tenant.get(tenant_id),
         {:ok, property} <- Property.get(property_id) do
      Schema.changeset(%Schema{}, %{
        amount: property.price,
        # TODO: make this configurable
        due_date: Date.utc_today() |> Date.add(1),
        tenant_id: tenant.id,
        property_id: property.id
      })
      |> Repo.insert()
    end
  end

  @doc """
  Marks the rent as paid.
  """
  @spec pay(integer()) :: {:ok, Schema.t()} | {:error, Ecto.Changeset.t() | String.t()}
  def pay(id) do
    with {:ok, rent} <- get(id) do
      Schema.changeset(rent, %{paid: true})
      |> Repo.update()
    end
  end

  @doc """
  Gets a number of unpaid rents.
  """
  @spec total_unpaid(integer()) :: integer()
  def total_unpaid(tenant_id) do
    from(r in Schema, where: r.tenant_id == ^tenant_id and r.paid == false)
    |> Repo.all()
    |> Enum.count()
  end

  @doc """
  Gets a number of overdue rents.
  """
  @spec total_overdue(integer()) :: integer()
  def total_overdue(tenant_id) do
    from(r in Schema,
      where: r.tenant_id == ^tenant_id and r.paid == false and r.due_date < ^Date.utc_today()
    )
    |> Repo.all()
    |> Enum.count()
  end

  @doc """
  Gets a number of unpaid rents without tenant id.
  """
  @spec total_unpaid() :: integer()
  def total_unpaid() do
    from(r in Schema, where: r.paid == false)
    |> Repo.all()
    |> Enum.count()
  end

  @doc """
  Gets a number of overdue rents without tenant id.
  """
  @spec total_overdue() :: integer()
  def total_overdue() do
    from(r in Schema, where: r.paid == false and r.due_date < ^Date.utc_today())
    |> Repo.all()
    |> Enum.count()
  end

  @doc """
  Gets a number of rents.
  """
  @spec total() :: integer()
  def total() do
    Repo.aggregate(Schema, :count, :id)
  end

  defp get_taxed_price(_, nil), do: {:error, "Currency not configured"}
  defp get_taxed_price(nil, currency), do: {:ok, Money.new(0, currency)}

  defp get_taxed_price({currency, income}, _),
    do: Property.get_taxed_price(Money.new(income, currency))
end
