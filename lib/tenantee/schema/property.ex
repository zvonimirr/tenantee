defmodule Tenantee.Schema.Property do
  @moduledoc """
  Property Ecto Schema.
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "properties" do
    field :name, :string
    field :description, :string, default: ""
    field :address, :string

    timestamps()
  end

  def changeset(property, params \\ %{}) do
    property
    |> cast(params, [:name, :description, :address])
    |> validate_required([:name, :address])
  end
end
