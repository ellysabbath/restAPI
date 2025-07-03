defmodule RestAPI.RasilimaliFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RestAPI.Rasilimali` context.
  """

  @doc """
  Generate a rasilima.
  """
  def rasilima_fixture(attrs \\ %{}) do
    {:ok, rasilima} =
      attrs
      |> Enum.into(%{
        gharama: "120.5",
        hali: "some hali",
        idadi_jumla: 42,
        idadi_ya_uhitaji: 42,
        imara: 42,
        jina_la_vifaa: "some jina_la_vifaa",
        uhitaji: "some uhitaji",
        vibovu: 42
      })
      |> RestAPI.Rasilimali.create_rasilima()

    rasilima
  end
end
