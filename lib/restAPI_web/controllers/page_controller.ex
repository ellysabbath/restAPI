defmodule RestAPIWeb.PageController do
  use RestAPIWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end

  def users(conn, _params) do
    IO.puts("users function hi!!")
    users=[
      %{id: 1, name: "elly", email: "mwananjelaelisha36@gmail.com"},
      %{id: 2, name: "zeb", email: "mwananjelazab@gmail.com"},
    ]
    # render(conn, :users,users: users, layout: false)
    json(conn, %{users: users})
  end
end
