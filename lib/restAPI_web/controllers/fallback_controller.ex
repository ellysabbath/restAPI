defmodule RestAPIWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use RestAPIWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(json: RestAPIWeb.ChangesetJSON)
    |> render(:error, changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(html: RestAPIWeb.ErrorHTML, json: RestAPIWeb.ErrorJSON)
    |> render(:"404")
  end

    def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> render(RestAPIWeb.ChangesetView, "error.json", changeset: changeset)
  end

  def call(conn, _) do
    conn
    |> put_status(:internal_server_error)
    |> json(%{error: "Something went wrong"})
  end
end
