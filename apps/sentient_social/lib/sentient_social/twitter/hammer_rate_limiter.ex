defmodule SentientSocial.Twitter.HammerRateLimiter do
  @moduledoc """
  Wrapper for the Hammer client
  """

  @behaviour SentientSocial.Twitter.RateLimiter

  @spec check(String.t(), integer, integer) :: {:allow, integer} | {:deny, integer}
  def check(key, time_scale, rate_limit) do
    Hammer.check_rate(key, time_scale, rate_limit)
  end
end
