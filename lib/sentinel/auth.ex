defmodule Sentinel.Auth do
  @github_app_id Application.get_env(:semantic_sentinel, :github_auth) |> Keyword.get(:app_id)

  def private_key_path() do
    key_file = Application.get_env(:semantic_sentinel, :github_auth) |> Keyword.get(:private_key_file)

    :code.priv_dir(:semantic_sentinel)
    |> Path.join(key_file)
  end

  def signer() do
    rsa_pem = private_key_path() |> File.read!
    Joken.Signer.create("RS256", %{"pem" => rsa_pem})
  end

  def token() do
    payload = %{
      iat: Joken.current_time(),
      exp: Joken.current_time() + 600,
      iss: @github_app_id,
    }

    Joken.generate_and_sign!(%{}, payload, signer())
  end
end
