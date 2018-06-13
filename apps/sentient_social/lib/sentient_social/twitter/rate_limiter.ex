defmodule SentientSocial.Twitter.RateLimiter do
  @moduledoc false

  @callback check(String.t(), integer, integer) :: {:allow, integer} | {:deny, integer}
end
