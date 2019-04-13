File.exists?(Path.expand("~/.iex.exs")) && import_file("~/.iex.exs")

alias SentientSocial.Repo
alias SentientSocial.Accounts
alias SentientSocial.Accounts.{Credential, Token, User}
# user = Repo.all(User) |> List.first
# ExTwitter.configure(Enum.concat(ExTwitter.Config.get_tuples(), access_token: user.access_token, access_token_secret: user.access_token_secret))
# stream = ExTwitter.stream_user() |> Stream.map(fn(x) -> IO.inspect(x) end)
# Enum.to_list(stream)
