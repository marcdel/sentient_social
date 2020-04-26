defmodule InlineLogger do
  require Logger

  def info(value, label: label) do
    Logger.info("#{label}: #{inspect(value)}")

    value
  end

  def info(value) do
    Logger.info(inspect(value))

    value
  end
end