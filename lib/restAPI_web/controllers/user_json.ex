defmodule RestAPIWeb.UserJSON do
  alias RestAPI.Accounts.User

  @doc """
  Renders a list of users.
  """
  def index(%{users: users}) do
    %{data: for(user <- users, do: data(user))}
  end

  @doc """
  Renders a single user.
  """
  def show(%{user: user}) do
    %{data: data(user)}
  end

  defp data(%User{} = user) do
    %{
      id: user.id,
      email: user.email,
      full_name: user.full_name,
      age: user.age,
      contact: user.contact,
      role: user.role
    }
  end
end
