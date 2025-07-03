defmodule RestAPI.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `RestAPI.Accounts` context.
  """

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> RestAPI.Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end

  @doc """
  Generate a deacon.
  """
  def deacon_fixture(attrs \\ %{}) do
    {:ok, deacon} =
      attrs
      |> Enum.into(%{
        age: 42,
        contact: "some contact",
        email: "some email",
        full_name: "some full_name",
        role: "some role"
      })
      |> RestAPI.Accounts.create_deacon()

    deacon
  end
end
