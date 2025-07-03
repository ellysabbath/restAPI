defmodule RestAPIWeb.DeaconController do
  use RestAPIWeb, :controller

  alias RestAPI.Accounts
  alias RestAPI.Accounts.Deacon

  action_fallback RestAPIWeb.FallbackController

  def index(conn, _params) do
    deacons = Accounts.list_deacons()
    render(conn, :index, deacons: deacons)
  end

  def create(conn, %{"deacon" => deacon_params}) do
    with {:ok, %Deacon{} = deacon} <- Accounts.create_deacon(deacon_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/deacons/#{deacon}")
      |> render(:show, deacon: deacon)
    end
  end

  def show(conn, %{"id" => id}) do
    deacon = Accounts.get_deacon!(id)
    render(conn, :show, deacon: deacon)
  end

  def update(conn, %{"id" => id, "deacon" => deacon_params}) do
    deacon = Accounts.get_deacon!(id)

    with {:ok, %Deacon{} = deacon} <- Accounts.update_deacon(deacon, deacon_params) do
      render(conn, :show, deacon: deacon)
    end
  end

  def delete(conn, %{"id" => id}) do
    deacon = Accounts.get_deacon!(id)

    with {:ok, %Deacon{}} <- Accounts.delete_deacon(deacon) do
      send_resp(conn, :no_content, "")
    end
  end
end
