defmodule RestAPIWeb.RasilimaController do
  use RestAPIWeb, :controller

  alias RestAPI.Rasilimali

  action_fallback RestAPIWeb.FallbackController

  def index(conn, _params) do
    rasilimali = Rasilimali.list_rasilimali()
    render(conn, :index, rasilimali: rasilimali)
  end

  def create(conn, %{"rasilima" => rasilima_params}) do
    with {:ok, %Rasilimali{} = rasilima} <- Rasilimali.create_rasilima(rasilima_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", ~p"/api/rasilimali/#{rasilima}")
      |> render(:show, rasilima: rasilima)
    end
  end

  def show(conn, %{"id" => id}) do
    rasilima = Rasilimali.get_rasilima!(id)
    render(conn, :show, rasilima: rasilima)
  end

  def update(conn, %{"id" => id, "rasilima" => rasilima_params}) do
    rasilima = Rasilimali.get_rasilima!(id)

    with {:ok, %Rasilimali{} = rasilima} <- Rasilimali.update_rasilima(rasilima, rasilima_params) do
      render(conn, :show, rasilima: rasilima)
    end
  end

  def delete(conn, %{"id" => id}) do
    rasilima = Rasilimali.get_rasilima!(id)

    with {:ok, %Rasilimali{}} <- Rasilimali.delete_rasilima(rasilima) do
      send_resp(conn, :no_content, "")
    end
  end
end
