defmodule RestAPIWeb.DeaconJSON do
  alias RestAPI.Accounts.Deacon

  @doc """
  Renders a list of deacons.
  """
  def index(%{deacons: deacons}) do
    %{data: for(deacon <- deacons, do: data(deacon))}
  end

  @doc """
  Renders a single deacon.
  """
  def show(%{deacon: deacon}) do
    %{data: data(deacon)}
  end

  defp data(%Deacon{} = deacon) do
    %{
      id: deacon.id,
      full_name: deacon.full_name,
      email: deacon.email,
      age: deacon.age,
      contact: deacon.contact,
      role: deacon.role
    }
  end
end
