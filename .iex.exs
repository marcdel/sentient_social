File.exists?(Path.expand("~/.iex.exs")) && import_file("~/.iex.exs")

alias SentientSocial.Repo
alias SentientSocial.Accounts
alias SentientSocial.Accounts.{User, Keyword}
