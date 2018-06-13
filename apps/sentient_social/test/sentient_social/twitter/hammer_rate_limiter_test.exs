defmodule SentientSocial.Twitter.HammerRateLimiterTest do
  use ExUnit.Case
  alias SentientSocial.Twitter.HammerRateLimiter

  test "calls hammer with the specified key, and rate limit" do
    assert {:allow, 1} = HammerRateLimiter.check("1", 60_000, 1)
    assert {:deny, 1} = HammerRateLimiter.check("1", 60_000, 1)
    assert {:allow, 1} = HammerRateLimiter.check("2", 60_000, 2)
    assert {:allow, 2} = HammerRateLimiter.check("2", 60_000, 2)
    assert {:deny, 2} = HammerRateLimiter.check("2", 60_000, 2)
  end
end
