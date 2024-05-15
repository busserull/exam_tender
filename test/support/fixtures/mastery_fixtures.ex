defmodule Et.MasteryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Et.Mastery` context.
  """

  @doc """
  Generate a verdict.
  """
  def verdict_fixture(attrs \\ %{}) do
    {:ok, verdict} =
      attrs
      |> Enum.into(%{
        topic_id: 42
      })
      |> Et.Mastery.create_verdict()

    verdict
  end
end
