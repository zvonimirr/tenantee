defmodule TenanteeWeb.ExpenseControllerTest do
  use TenanteeWeb.ConnCase

  describe "POST /api/expenses/:property_id" do
    test "happy path", %{conn: conn} do
      %{id: property_id} = Tenantee.Factory.Property.insert()

      conn =
        post(conn, "/api/expenses/#{property_id}", %{
          amount: %{
            amount: 100.00,
            currency: "USD"
          },
          description: "Broken sink"
        })

      assert json_response(conn, 201)["description"] == "Broken sink"
    end

    test "invalid parameters", %{conn: conn} do
      %{id: property_id} = Tenantee.Factory.Property.insert()

      conn =
        post(conn, "/api/expenses/#{property_id}", %{
          amount: %{
            currency: "USD"
          }
        })

      assert json_response(conn, 422)["message"] == "Invalid parameters"
    end
  end

  test "GET /api/expenses/monthly", %{conn: conn} do
    empty_conn = get(conn, "/api/expenses/monthly")

    assert json_response(empty_conn, 200) == %{
             "expenses" => []
           }

    %{id: property_id} = Tenantee.Factory.Property.insert()
    %{id: expense_id} = Tenantee.Factory.Expense.insert(property_id)

    conn = get(conn, "/api/expenses/monthly")

    assert List.first(json_response(conn, 200)["expenses"])["id"] == expense_id
  end

  describe "GET /api/expenses/:id" do
    test "happy path", %{conn: conn} do
      %{id: property_id} = Tenantee.Factory.Property.insert()
      %{id: expense_id} = Tenantee.Factory.Expense.insert(property_id)

      conn = get(conn, "/api/expenses/#{expense_id}")

      assert json_response(conn, 200)["id"] == expense_id
    end

    test "not found", %{conn: conn} do
      conn = get(conn, "/api/expenses/0")

      assert json_response(conn, 404)["message"] == "Expense not found"
    end
  end

  describe "PATCH /api/expenses/:id" do
    test "happy path", %{conn: conn} do
      %{id: property_id} = Tenantee.Factory.Property.insert()
      %{id: expense_id} = Tenantee.Factory.Expense.insert(property_id)

      conn =
        patch(conn, "/api/expenses/#{expense_id}", %{
          amount: %{
            amount: 100.00,
            currency: "USD"
          },
          description: "Broken sink"
        })

      assert json_response(conn, 200)["description"] == "Broken sink"
    end

    test "happy path (with string price)", %{conn: conn} do
      %{id: property_id} = Tenantee.Factory.Property.insert()
      %{id: expense_id} = Tenantee.Factory.Expense.insert(property_id)

      conn =
        patch(conn, "/api/expenses/#{expense_id}", %{
          amount: %{
            amount: "100.00",
            currency: "USD"
          },
          description: "Broken sink"
        })

      assert json_response(conn, 200)["description"] == "Broken sink"
    end

    test "not found", %{conn: conn} do
      conn =
        patch(conn, "/api/expenses/0", %{
          amount: %{
            amount: 100.00,
            currency: "USD"
          },
          description: "Broken sink"
        })

      assert json_response(conn, 404)["message"] == "Expense not found"
    end

    test "invalid price", %{conn: conn} do
      %{id: property_id} = Tenantee.Factory.Property.insert()
      %{id: expense_id} = Tenantee.Factory.Expense.insert(property_id)

      conn =
        patch(conn, "/api/expenses/#{expense_id}", %{
          amount: %{
            amount: "invalid",
            currency: "USD"
          }
        })

      assert json_response(conn, 422)["message"] == "Invalid price"
    end

    test "invalid parameters", %{conn: conn} do
      %{id: property_id} = Tenantee.Factory.Property.insert()
      %{id: expense_id} = Tenantee.Factory.Expense.insert(property_id)

      conn =
        patch(conn, "/api/expenses/#{expense_id}", %{
          amount: %{
            currency: "USD"
          }
        })

      assert json_response(conn, 422)["message"] == "Invalid parameters"
    end
  end

  describe "DELETE /api/expenses/:id" do
    test "happy path", %{conn: conn} do
      %{id: property_id} = Tenantee.Factory.Property.insert()
      %{id: expense_id} = Tenantee.Factory.Expense.insert(property_id)

      conn = delete(conn, "/api/expenses/#{expense_id}")

      assert json_response(conn, 200)["message"] == "Expense deleted"
    end

    test "not found", %{conn: conn} do
      conn = delete(conn, "/api/expenses/0")

      assert json_response(conn, 404)["message"] == "Expense not found"
    end
  end
end
