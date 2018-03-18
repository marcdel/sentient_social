defmodule SentientSocialTest do
  use ExUnit.Case
  doctest SentientSocial

  test "greets the world" do
    assert SentientSocial.hello() == :world
  end
end
