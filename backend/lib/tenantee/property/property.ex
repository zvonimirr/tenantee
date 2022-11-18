defmodule Tenantee.Property do
  alias Tenantee.Repo
  alias Tenantee.Property.Schema

  def create_property(attrs) do
    %Schema{}
    |> Schema.changeset(attrs)
    |> Repo.insert()
  end
end
