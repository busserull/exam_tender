defmodule Et.Quiz.Henry do
  import Et.Quiz.Utils

  def question do
    template =
      [
        :n2_in_water,
        :n2_leaving_blood,
        :co2_in_pools
      ]
      |> Enum.random()

    apply(__MODULE__, template, [])
  end

  def n2_in_water do
    p0 = 1.0
    n2_1_bar = 20.0

    p = rand_range(6, 12, 0.5)

    n2_p = n2_1_bar * p / p0

    correct = n2_p

    incorrect = [
      n2_1_bar,
      0.85 * n2_1_bar,
      0.8 * n2_p
    ]

    {correct_id, options} = make_options(correct, incorrect, "mg")

    text = [
      "Roughly #{r1(n2_1_bar)} milligrams of nitrogen gas can be dissolved in a liter of water" <>
        " at atmospheric pressure.",
      "How much nitrogen gas can be dissolved if you increase the ambient pressure to #{r1(p)} bar?"
    ]

    explanation = [
      "Henry's law states that the amount of gas that can be dissolved in liquid is proportional" <>
        " to the ambient pressure.",
      "The amount of nitrogen gas we can dissolve in 1 liter of water at #{r1(p)} bar is" <>
        " therefore #{r2(n2_p)} mg."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end

  def n2_leaving_blood do
    p0 = 1.0
    n2_blood_surface = 75.0

    depth = rand_range(36, 54)
    p1 = p0 + depth / 10.0

    n2_depth = n2_blood_surface * p1 / p0

    correct = n2_depth - n2_blood_surface

    incorrect = [
      n2_depth,
      3.0 * n2_depth,
      rand_range(145, 345)
    ]

    {correct_id, options} = make_options(correct, incorrect, "ml")

    text = [
      "About #{r0(n2_blood_surface)} milliliters of nitrogen gas is dissolved in the blood of a human" <>
        " at the surface.",
      "If you have been diving at #{r0(depth)} meters long enough to become saturated, how" <>
        " much nitrogen has to leave your blood as you return to the surface?"
    ]

    explanation = [
      "Henry's law states that the amount of gas that can be dissolved in liquid is proportional" <>
        " to the ambient pressure.",
      "At #{r0(depth)}, the ambient pressure is #{r2(p1)} bar, meaning that around #{r2(n2_depth)}" <>
        " surface milliliters of nitrogen can be dissolved in the blood of a human if you wait" <>
        " for them to become saturated.",
      "As they return to the surface, they hence have to drop (#{r2(n2_depth)} - #{r2(n2_blood_surface)} ml)" <>
        " = #{r2(n2_depth - n2_blood_surface)} ml of nitrogen from their blood."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end

  def co2_in_pools do
    p0 = 1.0
    h0 = rand_range(2.27, 2.63, 0.01)

    p1 = rand_range(56, 84)
    h1 = h0 * p1 / p0

    correct = h1

    incorrect = [
      2.3 * h0,
      0.5 * h1,
      rand_range(8.5, 10.1, 0.1)
    ]

    {correct_id, options} = make_options(correct, incorrect, "g")

    text = [
      "About #{r2(h0)} grams of carbon dioxide is dissolved in an opened bottle of soda.",
      "How much carbon dioxide could you dissolve in the soda if you increased the ambient" <>
        " pressure all the way to #{r0(p1)} bar?"
    ]

    explanation = [
      "Henry's law states that the amount of gas that can be dissolved in liquid is proportional" <>
        " to the ambient pressure.",
      "At #{r0(p1)} bar ambient pressure, you would be able to dissolve approximately #{r2(h1)} g" <>
        " of CO<sub>2</sub>."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end
end
