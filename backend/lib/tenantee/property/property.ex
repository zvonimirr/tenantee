defmodule Tenantee.Property do
  alias Tenantee.Repo
  alias Tenantee.Property.Schema

  def create_property(attrs) do
    %Schema{}
    |> Schema.changeset(attrs)
    |> Repo.insert()
  end

  def get_property(id) do
    Repo.get(Schema, id)
  end

  def get_all_properties do
    Repo.all(Schema)
  end
end
