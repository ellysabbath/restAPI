defmodule RestAPIWeb.Web.RasilimaControllerTest do
  use RestAPIWeb.ConnCase

  import RestAPI.RasilimaliFixtures

  alias RestAPI.Rasilimali.Rasilima

  @create_attrs %{
    gharama: "120.5",
    hali: "some hali",
    idadi_jumla: 42,
    idadi_ya_uhitaji: 42,
    imara: 42,
    jina_la_vifaa: "some jina_la_vifaa",
    uhitaji: "some uhitaji",
    vibovu: 42
  }
  @update_attrs %{
    gharama: "456.7",
    hali: "some updated hali",
    idadi_jumla: 43,
    idadi_ya_uhitaji: 43,
    imara: 43,
    jina_la_vifaa: "some updated jina_la_vifaa",
    uhitaji: "some updated uhitaji",
    vibovu: 43
  }
  @invalid_attrs %{gharama: nil, hali: nil, idadi_jumla: nil, idadi_ya_uhitaji: nil, imara: nil, jina_la_vifaa: nil, uhitaji: nil, vibovu: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all rasilimali", %{conn: conn} do
      conn = get(conn, ~p"/api/web/rasilimali")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create rasilima" do
    test "renders rasilima when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/web/rasilimali", rasilima: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/web/rasilimali/#{id}")

      assert %{
               "id" => ^id,
               "gharama" => "120.5",
               "hali" => "some hali",
               "idadi_jumla" => 42,
               "idadi_ya_uhitaji" => 42,
               "imara" => 42,
               "jina_la_vifaa" => "some jina_la_vifaa",
               "uhitaji" => "some uhitaji",
               "vibovu" => 42
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/web/rasilimali", rasilima: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update rasilima" do
    setup [:create_rasilima]

    test "renders rasilima when data is valid", %{conn: conn, rasilima: %Rasilima{id: id} = rasilima} do
      conn = put(conn, ~p"/api/web/rasilimali/#{rasilima}", rasilima: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/web/rasilimali/#{id}")

      assert %{
               "id" => ^id,
               "gharama" => "456.7",
               "hali" => "some updated hali",
               "idadi_jumla" => 43,
               "idadi_ya_uhitaji" => 43,
               "imara" => 43,
               "jina_la_vifaa" => "some updated jina_la_vifaa",
               "uhitaji" => "some updated uhitaji",
               "vibovu" => 43
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, rasilima: rasilima} do
      conn = put(conn, ~p"/api/web/rasilimali/#{rasilima}", rasilima: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete rasilima" do
    setup [:create_rasilima]

    test "deletes chosen rasilima", %{conn: conn, rasilima: rasilima} do
      conn = delete(conn, ~p"/api/web/rasilimali/#{rasilima}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/web/rasilimali/#{rasilima}")
      end
    end
  end

  defp create_rasilima(_) do
    rasilima = rasilima_fixture()
    %{rasilima: rasilima}
  end
end
