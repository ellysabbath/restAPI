defmodule RestAPIWeb.Web.ServiceControllerTest do
  use RestAPIWeb.ConnCase

  import RestAPI.ServicesFixtures

  alias RestAPI.Services.Service

  @create_attrs %{
    aina_ya_changamoto: "some aina_ya_changamoto",
    idadi_ya_watu_ulio_waombea: "some idadi_ya_watu_ulio_waombea",
    idadi_ya_watu_walio_saidiwa: "some idadi_ya_watu_walio_saidiwa",
    jina_kamili_la_mshiriki: "some jina_kamili_la_mshiriki",
    kiasi: "some kiasi",
    kufanyika_maombi: "some kufanyika_maombi",
    tarehe: "some tarehe",
    watu_walio_ombewa: "some watu_walio_ombewa"
  }
  @update_attrs %{
    aina_ya_changamoto: "some updated aina_ya_changamoto",
    idadi_ya_watu_ulio_waombea: "some updated idadi_ya_watu_ulio_waombea",
    idadi_ya_watu_walio_saidiwa: "some updated idadi_ya_watu_walio_saidiwa",
    jina_kamili_la_mshiriki: "some updated jina_kamili_la_mshiriki",
    kiasi: "some updated kiasi",
    kufanyika_maombi: "some updated kufanyika_maombi",
    tarehe: "some updated tarehe",
    watu_walio_ombewa: "some updated watu_walio_ombewa"
  }
  @invalid_attrs %{aina_ya_changamoto: nil, idadi_ya_watu_ulio_waombea: nil, idadi_ya_watu_walio_saidiwa: nil, jina_kamili_la_mshiriki: nil, kiasi: nil, kufanyika_maombi: nil, tarehe: nil, watu_walio_ombewa: nil}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all services", %{conn: conn} do
      conn = get(conn, ~p"/api/web/services")
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create service" do
    test "renders service when data is valid", %{conn: conn} do
      conn = post(conn, ~p"/api/web/services", service: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, ~p"/api/web/services/#{id}")

      assert %{
               "id" => ^id,
               "aina_ya_changamoto" => "some aina_ya_changamoto",
               "idadi_ya_watu_ulio_waombea" => "some idadi_ya_watu_ulio_waombea",
               "idadi_ya_watu_walio_saidiwa" => "some idadi_ya_watu_walio_saidiwa",
               "jina_kamili_la_mshiriki" => "some jina_kamili_la_mshiriki",
               "kiasi" => "some kiasi",
               "kufanyika_maombi" => "some kufanyika_maombi",
               "tarehe" => "some tarehe",
               "watu_walio_ombewa" => "some watu_walio_ombewa"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, ~p"/api/web/services", service: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update service" do
    setup [:create_service]

    test "renders service when data is valid", %{conn: conn, service: %Service{id: id} = service} do
      conn = put(conn, ~p"/api/web/services/#{service}", service: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, ~p"/api/web/services/#{id}")

      assert %{
               "id" => ^id,
               "aina_ya_changamoto" => "some updated aina_ya_changamoto",
               "idadi_ya_watu_ulio_waombea" => "some updated idadi_ya_watu_ulio_waombea",
               "idadi_ya_watu_walio_saidiwa" => "some updated idadi_ya_watu_walio_saidiwa",
               "jina_kamili_la_mshiriki" => "some updated jina_kamili_la_mshiriki",
               "kiasi" => "some updated kiasi",
               "kufanyika_maombi" => "some updated kufanyika_maombi",
               "tarehe" => "some updated tarehe",
               "watu_walio_ombewa" => "some updated watu_walio_ombewa"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, service: service} do
      conn = put(conn, ~p"/api/web/services/#{service}", service: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete service" do
    setup [:create_service]

    test "deletes chosen service", %{conn: conn, service: service} do
      conn = delete(conn, ~p"/api/web/services/#{service}")
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, ~p"/api/web/services/#{service}")
      end
    end
  end

  defp create_service(_) do
    service = service_fixture()
    %{service: service}
  end
end
