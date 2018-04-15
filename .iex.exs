File.exists?(Path.expand("~/.iex.exs")) && import_file("~/.iex.exs")

alias SentientSocial.Repo
alias SentientSocial.Accounts
alias SentientSocial.Accounts.{User, Keyword}
alias SentientSocial.Twitter.TweetFinder

{:ok, user} =
  case Accounts.get_user_by_username("marcdel") do
    nil ->
      {:ok, user} =
        Accounts.create_user(%{
          username: "marcdel",
          name: "Marc Delagrammatikas",
          profile_image_url: "image.png"
        })

    user ->
      {:ok, user}
  end
