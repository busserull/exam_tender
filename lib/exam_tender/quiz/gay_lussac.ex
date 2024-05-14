defmodule Et.Quiz.GayLussac do
  import Et.Quiz.Utils

  def question do
    template =
      [
        :bottle_cool_down,
        :outside_temperature,
        :bottle_burst
      ]
      |> Enum.random()

    apply(__MODULE__, template, [])
  end

  def bottle_cool_down do
    t_cel_0 = rand_range(22, 30, 0.5)
    t_cel_1 = rand_range(6, 9, 0.5)

    t0 = t_cel_0 + 273.15
    t1 = t_cel_1 + 273.15

    p0 = rand_range(220, 310, 10)
    p1 = p0 * t1 / t0

    correct = p1

    incorrect = [
      p1 * 0.5,
      p0 * t_cel_1 / t_cel_0,
      p0 * 1.12
    ]

    {correct_id, options} = make_options(correct, incorrect, "bar")

    text = [
      "It is a warm day, and you go diving. The ambient temperature is #{r1(t_cel_0)} °C" <>
        " when you start. Your bailout, which has a pressure of #{r0(p0)} bar, has warmed up" <>
        " fully to this temperature before you go in the water.",
      "At the end of your dive, your bailout has cooled down to the water temperature of #{r1(t_cel_1)} °C," <>
        " but you have not used any of its gas supply.",
      "What is the pressure of your bailout now?"
    ]

    explanation = [
      "Gay-Lussac's law states that the ratio of pressure to temperature stays the constant, given that" <>
        " the volume does not change.",
      "An important thing to note here is that we always deal with absolute temperature, namely Kelvin (K).",
      "At the start of the dive, the bottle has a temperature of (#{r1(t_cel_0)} °C) = (#{r2(t0)} K).",
      "Hence, its pressure-to-temperature ratio is (#{r2(p0 / t0)} bar / K).",
      "When it has cooled down, its pressure is (#{r2(p0 / t0)} bar / K) * (#{r2(t1)} K) = #{r2(p1)} bar."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end

  def outside_temperature do
    t_cel_0 = rand_range(-6, 28, 0.5)
    t_cel_1 = rand_range(18, 22, 0.5)

    t0 = t_cel_0 + 273.15
    t1 = t_cel_1 + 273.15

    p0 = rand_range(220, 310, 10)
    p1 = p0 * t1 / t0

    correct = t_cel_0

    incorrect = [
      t_cel_0 * 0.5,
      t_cel_0 * 1.26,
      t_cel_0 + 5.0
    ]

    {correct_id, options} = make_options(correct, incorrect, "°C")

    text = [
      "A bailout bottle has been left outside for a long while." <>
        " When you bring it inside, it has a pressure of #{r2(p0)} bar.",
      "Inside you keep a temperature of #{r1(t_cel_1)} °C, and after the bottle has" <>
        " acclimatized, you measure its pressure to be #{r2(p1)} bar.",
      "What is the outside temperature?"
    ]

    explanation = [
      "Gay-Lussac's law states that the ratio of pressure to temperature stays the constant, given that" <>
        " the volume does not change.",
      "An important thing to note here is that we always deal with absolute temperature, namely Kelvin (K).",
      "The pressure-to-temperature ratio inside is (#{r2(p1)} bar) / (#{r2(t1)} K) = (#{r2(p1 / t1)} bar / K).",
      "You know the pressure the bottle had outside, so the outside temperature must be" <>
        " (#{r2(p0)} bar) / (#{r2(p1 / t1)} bar / K) = (#{r2(t0)} K) = #{r2(t_cel_0)} °C."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end

  def bottle_burst do
    t_cel_0 = rand_range(18, 22, 0.5)

    t0 = t_cel_0 + 273.15

    p0 = rand_range(200, 232, 1)
    p1 = p0 * rand_range(1.4, 1.8, 0.1)

    t1 = t0 * p1 / p0
    t_cel_1 = t1 - 273.15

    correct = t_cel_1

    incorrect = [
      t1,
      t0,
      t_cel_1 * 1.5
    ]

    {correct_id, options} = make_options(correct, incorrect, "°C")

    text = [
      "Your scuba tank has a burst disc (a safety device to let out excessive pressure) that will" <>
        " rupture at #{r2(p1)} bar.",
      "When filled, your tank has a pressure of #{r2(p0)} bar, and holds a temperature of #{r2(t_cel_0)} °C.",
      "To what temperature would you have to heat the bottle to make the burst disc rupture?"
    ]

    explanation = [
      "Gay-Lussac's law states that the ratio of pressure to temperature stays the constant, given that" <>
        " the volume does not change.",
      "An important thing to note here is that we always deal with absolute temperature, namely Kelvin (K).",
      "When the tank is filled, it has a pressure-to-temperature ratio of (#{r2(p0 / t0)} bar / K).",
      "You know the pressure required to make the burst disc rupture, so the temperature necessary" <>
        " becomes (#{r2(p1)} bar) / (#{r2(p0 / t0)} bar / K) = (#{r2(t1)} K) = #{r2(t_cel_1)} °C."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end
end
