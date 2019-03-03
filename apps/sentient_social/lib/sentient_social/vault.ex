defmodule SentientSocial.Vault do
  use Cloak.Vault, otp_app: :sentient_social

  @impl GenServer
  def init(config) do
    config =
      Keyword.put(config, :ciphers,
        default: {Cloak.Ciphers.AES.CTR, tag: "AES.V2", key: decode_env("CLOAK_KEY")},
        retired:
          {Cloak.Ciphers.Deprecated.AES.CTR,
           module_tag: "AES", tag: <<1>>, key: decode_env("CLOAK_KEY")}
      )

    {:ok, config}
  end

  defp decode_env(var) do
    var
    |> System.get_env()
    |> Base.decode64!()
  end
end
