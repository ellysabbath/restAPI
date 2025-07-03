defmodule RestAPIWeb.RasilimaJSON do
  alias RestAPI.Rasilimali

  @doc """
  Renders a list of rasilimali.
  """
  def index(%{rasilimali: rasilimali}) do
    %{data: for(rasilima <- rasilimali, do: data(rasilima))}
  end

  @doc """
  Renders a single rasilima.
  """
  def show(%{rasilima: rasilima}) do
    %{data: data(rasilima)}
  end

  defp data(%Rasilimali{} = rasilima) do
    %{
      id: rasilima.id,
      jina_la_vifaa: rasilima.jina_la_vifaa,
      idadi_jumla: rasilima.idadi_jumla,
      hali: rasilima.hali,
      imara: rasilima.imara,
      vibovu: rasilima.vibovu,
      uhitaji: rasilima.uhitaji,
      idadi_ya_uhitaji: rasilima.idadi_ya_uhitaji,
      gharama: rasilima.gharama
    }
  end
end
