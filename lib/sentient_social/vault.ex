defmodule SentientSocial.Vault do
  use Cloak.Vault, otp_app: :sentient_social

  @impl GenServer
  def init(config) do
    config = put_ciphers(config)
    {:ok, config}
  end

  # If we already have a default cipher, don't overwrite.
  # This is hardcoded in config/test.exs so we don't need to read from an env variable.
  defp put_ciphers([ciphers: [default: _]] = config), do: config

  defp put_ciphers(config) do
    Keyword.put(config, :ciphers,
      default: {Cloak.Ciphers.AES.GCM, tag: "AES.GCM.V1", key: decode_key!()}
    )
  end

  defp decode_key!() do
    :sentient_social
    |> Application.get_env(:cloak_key)
    |> Base.decode64!()
  end
end
