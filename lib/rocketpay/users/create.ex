defmodule Rocketpay.Users.Create do
  alias Rocketpay.{User, Account}
  alias Ecto.Multi

  def call(params) do
    Multi.new()
      |> Multi.insert(:create_user, User.changeset(params))
      |> Multi.run(:create_account, fn repo, %{create_user: user} ->
        insert_account(repo, user)
      end)
  end

  defp insert_account(repo, user) do
    user.id
      |> account_changeset()
      |> repo.insert()
  end

  defp account_changeset(user_id) do
    params = %{user_id: user_id, balance: "0.00"}

    Account.changeset(params)

  end
end
