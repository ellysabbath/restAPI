defmodule RestAPI.RasilimaliTest do
  use RestAPI.DataCase

  alias RestAPI.Rasilimali

  describe "rasilimali" do
    alias RestAPI.Rasilimali.Rasilima

    import RestAPI.RasilimaliFixtures

    @invalid_attrs %{gharama: nil, hali: nil, idadi_jumla: nil, idadi_ya_uhitaji: nil, imara: nil, jina_la_vifaa: nil, uhitaji: nil, vibovu: nil}

    test "list_rasilimali/0 returns all rasilimali" do
      rasilima = rasilima_fixture()
      assert Rasilimali.list_rasilimali() == [rasilima]
    end

    test "get_rasilima!/1 returns the rasilima with given id" do
      rasilima = rasilima_fixture()
      assert Rasilimali.get_rasilima!(rasilima.id) == rasilima
    end

    test "create_rasilima/1 with valid data creates a rasilima" do
      valid_attrs = %{gharama: "120.5", hali: "some hali", idadi_jumla: 42, idadi_ya_uhitaji: 42, imara: 42, jina_la_vifaa: "some jina_la_vifaa", uhitaji: "some uhitaji", vibovu: 42}

      assert {:ok, %Rasilima{} = rasilima} = Rasilimali.create_rasilima(valid_attrs)
      assert rasilima.gharama == Decimal.new("120.5")
      assert rasilima.hali == "some hali"
      assert rasilima.idadi_jumla == 42
      assert rasilima.idadi_ya_uhitaji == 42
      assert rasilima.imara == 42
      assert rasilima.jina_la_vifaa == "some jina_la_vifaa"
      assert rasilima.uhitaji == "some uhitaji"
      assert rasilima.vibovu == 42
    end

    test "create_rasilima/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Rasilimali.create_rasilima(@invalid_attrs)
    end

    test "update_rasilima/2 with valid data updates the rasilima" do
      rasilima = rasilima_fixture()
      update_attrs = %{gharama: "456.7", hali: "some updated hali", idadi_jumla: 43, idadi_ya_uhitaji: 43, imara: 43, jina_la_vifaa: "some updated jina_la_vifaa", uhitaji: "some updated uhitaji", vibovu: 43}

      assert {:ok, %Rasilima{} = rasilima} = Rasilimali.update_rasilima(rasilima, update_attrs)
      assert rasilima.gharama == Decimal.new("456.7")
      assert rasilima.hali == "some updated hali"
      assert rasilima.idadi_jumla == 43
      assert rasilima.idadi_ya_uhitaji == 43
      assert rasilima.imara == 43
      assert rasilima.jina_la_vifaa == "some updated jina_la_vifaa"
      assert rasilima.uhitaji == "some updated uhitaji"
      assert rasilima.vibovu == 43
    end

    test "update_rasilima/2 with invalid data returns error changeset" do
      rasilima = rasilima_fixture()
      assert {:error, %Ecto.Changeset{}} = Rasilimali.update_rasilima(rasilima, @invalid_attrs)
      assert rasilima == Rasilimali.get_rasilima!(rasilima.id)
    end

    test "delete_rasilima/1 deletes the rasilima" do
      rasilima = rasilima_fixture()
      assert {:ok, %Rasilima{}} = Rasilimali.delete_rasilima(rasilima)
      assert_raise Ecto.NoResultsError, fn -> Rasilimali.get_rasilima!(rasilima.id) end
    end

    test "change_rasilima/1 returns a rasilima changeset" do
      rasilima = rasilima_fixture()
      assert %Ecto.Changeset{} = Rasilimali.change_rasilima(rasilima)
    end
  end
end
