defmodule Tenantee.Data.PropertyTest do
  use Tenantee.DataCase
  alias Tenantee.Entity.Property
  import Tenantee.Test.Factory.{Property, Tenant}

  test "creates a property" do
    assert {:ok, _property} =
             Property.create(%{
               name: Faker.Person.first_name(),
               address: Faker.Address.street_address(),
               price: Money.new(1000, :USD)
             })
  end

  test "updates a property" do
    {:ok, property} = generate_property()

    assert :ok = Property.update(property.id, %{name: "New name"})
  end

  test "deletes a property" do
    {:ok, property} = generate_property()

    assert :ok = Property.delete(property.id)
  end

  test "gets all properties" do
    {:ok, _property} = generate_property()

    assert [] != Property.all()
  end

  test "gets property count" do
    {:ok, _property} = generate_property()

    assert 1 = Property.count()
  end

  test "gets property by id" do
    {:ok, property} = generate_property()

    {:ok, found_property} = Property.get(property.id)

    assert found_property.id == property.id
  end

  test "toggles lease" do
    {:ok, tenant} = generate_tenant()
    {:ok, property} = generate_property()

    1..2
    |> Enum.each(fn _ ->
      assert :ok =
               Property.toggle_lease(
                 Repo.preload(
                   property,
                   :tenants
                 ),
                 Repo.preload(tenant, :properties)
               )
    end)
  end

  test "errors when getting property by id" do
    assert {:error, "Property not found"} = Property.get(-1)
  end

  test "errors when deleting property" do
    assert {:error, "Property not found"} = Property.delete(-1)
  end

  test "errors when updating property" do
    assert {:error, "Property not found"} = Property.update(-1, %{name: "New name"})
  end
end
