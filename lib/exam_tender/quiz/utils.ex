defmodule Et.Quiz.Utils do
  def make_options(correct, incorrect, unit) do
    options =
      [{correct, true} | Enum.map(incorrect, &{&1, false})]
      |> Enum.shuffle()
      |> Enum.zip(0..(Enum.count(incorrect) + 1))
      |> Enum.map(fn {{option, correct?}, id} ->
        %{
          id: id,
          text: "#{r2(option)} #{unit}",
          correct?: correct?
        }
      end)

    correct_id =
      options
      |> Enum.find(& &1.correct?)
      |> Map.fetch!(:id)

    {correct_id, options}
  end

  def r0(number), do: round(number, 0)
  def r1(number), do: round(number, 1)
  def r2(number), do: round(number, 2)

  defp round(number, to), do: number |> Decimal.from_float() |> Decimal.round(to)

  def rand_range(min, max), do: (min - 1 + :rand.uniform(max - min)) * 1.0

  def rand_range(min, max, step) do
    (min - step + :rand.uniform(floor((max - min) / step) + 1) * step) * 1.0
  end
end
