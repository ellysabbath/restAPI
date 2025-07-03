defmodule RestAPI.Repo do
  use Ecto.Repo,
    otp_app: :restAPI,
    adapter: Ecto.Adapters.Postgres
end
