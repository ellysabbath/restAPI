defmodule RestAPIWeb.DeaconControllerTest do
  use RestAPIWeb.ConnCase

  import RestAPI.AccountsFixtures

  alias RestAPI.Accounts.Deacon

  @create_attrs %{
    age: 42,
    contact: "some contact",
    email: "some email",
    full_name: "some full_name",
    role: "some role"
  }
  @update_attrs %{
    age: 43,
    contact: "some updated contact",
    email: "some updated email",
    full_name: "some updated full_name",
    role: "some updated role"
  }
  @invalid_attrs %{age: nil, contact: nil, email: nil, full_name: nil, role: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all deacons", %{conn: conn} do
      conn = get(conn, ~p"/api/deacons")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create deacon" do
    test "renders deacon when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/deacons", deacon: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/deacons/#{id}")

      assert %{
               "id" => ^id,
               "age" => 42,
               "contact" => "some contact",
               "email" => "some email",
               "full_name" => "some full_name",
               "role" => "some role"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/deacons", deacon: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update deacon" do
    setup [:create_deacon]

    test "renders deacon when data is valid", %{conn: conn, deacon: %Deacon{id: id} = deacon} do
      conn = put(conn, ~p"/api/deacons/#{deacon}", deacon: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/deacons/#{id}")

      assert %{
               "id" => ^id,
               "age" => 43,
               "contact" => "some updated contact",
               "email" => "some updated email",
               "full_name" => "some updated full_name",
               "role" => "some updated role"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, deacon: deacon} do
      conn = put(conn, ~p"/api/deacons/#{deacon}", deacon: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete deacon" do
    setup [:create_deacon]

    test "deletes chosen deacon", %{conn: conn, deacon: deacon} do
      conn = delete(conn, ~p"/api/deacons/#{deacon}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/deacons/#{deacon}")
      end
    end
  end

  defp create_deacon(_) do
    deacon = deacon_fixture()
    %{deacon: deacon}
  end
end
