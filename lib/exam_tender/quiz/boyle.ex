defmodule Et.Quiz.Boyle do
  import Et.Quiz.Utils

  def question do
    template =
      [
        :balloon_submerge,
        :balloon_burst,
        :bubble_blow,
        :lift_bag
      ]
      |> Enum.random()

    apply(__MODULE__, template, [])
  end

  def lift_bag do
    lift_bag_volume = rand_range(368, 728)
    dive_depth = rand_range(8, 29)

    p_top = 1.0
    p_bot = p_top + dive_depth / 10.0
    v_bot = lift_bag_volume
    v_top = v_bot * p_bot / p_top

    correct = v_top

    incorrect = [
      v_bot,
      0.5 * v_top,
      2.0 * v_top
    ]

    {correct_id, options} = make_options(correct, incorrect, "liters")

    text = [
      "You are diving at #{r0(dive_depth)} meters, and you need to fill a lift bag" <>
        " with a volume of #{r1(lift_bag_volume)} liters.",
      "How many surface liters (or <em>normal liters</em>) is needed?"
    ]

    explanation = [
      "From Boyle's law, we know that the product of pressure and volume stays the same," <>
        " given constant temperature.",
      "At #{r0(dive_depth)} meters, we experience a pressure of #{r2(p_bot)} bar, so we" <>
        " have a product of (#{r2(v_bot)} L) * (#{r2(p_bot)} bar) = (#{r2(v_bot * p_bot)} L * bar).",
      "Divide this by the surface pressure of #{r0(p_top)} bar to get #{r2(v_top)} L."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end

  def bubble_blow do
    dive_depth = rand_range(18, 43)
    bubble_blow = rand_range(0.4, 0.9, 0.1)

    p_top = 1.0
    p_bot = p_top + dive_depth / 10.0
    v_bot = bubble_blow
    v_top = p_bot * v_bot / p_top

    correct = v_top

    incorrect = [
      v_bot,
      0.5 * v_bot,
      dive_depth / 10.0 * v_bot
    ]

    {correct_id, options} = make_options(correct, incorrect, "liters")

    text = [
      "You are on a dive to #{r2(dive_depth)} meters. You blow out a bubble that has" <>
        " a volume of #{r2(v_bot)} liters.",
      "Assuming that the bubble stays together, what volume does it have when it" <>
        " reaches the surface?"
    ]

    explanation = [
      "Boyle's law tells us that the product of pressure and volume stays constant," <>
        " as long as the temperature does not change.",
      "At the bottom, the pressure is #{r2(p_bot)} bar, and the bubble has a volume" <>
        " of #{r2(v_bot)} L.",
      " At the surface, the pressure is #{r2(p_top)} bar, so we can calculate the" <>
        " bubble's volume as (#{r2(v_bot)} L) * (#{r2(p_bot)} bar) / (#{r2(p_top)} bar)" <>
        " = #{r2(v_top)} liters."
    ]

    %{
      text: text,
      explanation: explanation,
      options: options,
      correct: correct_id
    }
  end

  def balloon_burst do
    dive_depth = rand_range(36, 50)

    burst_depth = rand_range(2.6, 5.2, 0.1)
    burst_volume = rand_range(6.8, 8.5, 0.1)
    p_burst = 1.0 + burst_depth / 10.0

    p_top = p_burst
    v_top = burst_volume

    p_bot = 1.0 + dive_depth / 10.0
    v_bot = p_top * v_top / p_bot

    correct = burst_depth

    incorrect = [
      burst_depth - 1.3,
      burst_depth * 0.75,
      2.1 * burst_depth
    ]

    {correct_id, options} = make_options(correct, incorrect, "meters")

    text = [
      "You bring an empty balloon with you on a dive to #{r0(dive_depth)} meters." <>
        " When there, you use your pneumo tube to inflate the balloon to a volume of" <>
        " #{r2(v_bot)} liters. Then you let the balloon go.",
      "From earlier tests, you know that your balloon will burst at #{r2(burst_volume)} liters.",
      "At what depth will your balloon explode?"
    ]

    explanation = [
      "Boyle's law tells us that the product of pressure and volume stays constant," <>
        " as long as the temperature does not change.",
      "When you are down at #{r2(dive_depth)} meters, the pressure is #{r2(p_bot)} bar, so" <>
        " the product becomes (#{r2(p_bot)} bar) * (#{r2(v_bot)} L) = (#{r2(p_bot * v_bot)} L * bar).",
      "You know that the balloon explodes when it reaches #{r2(burst_volume)} L.",
      "We can then use Boyle's law to find the explosion pressure, namely" <>
        " (#{r2(p_bot * v_bot)} L * bar) / (#{r2(v_top)} L) = (#{r2(p_top)} bar).",
      "Now we just need to translate #{r2(p_top)} bar to meters: 10 * (#{r2(p_top)} - 1) = #{r2(burst_depth)} meters."
    ]

    %{
      text: text,
      explanation: explanation,
      options: options,
      correct: correct_id
    }
  end

  def balloon_submerge do
    surface_volume = rand_range(2, 6)
    submersion = rand_range(10, 40)

    p0 = 1
    p1 = p0 + submersion / 10

    v1 = p0 * surface_volume / p1

    correct = v1

    incorrect = [
      2 * p0 * surface_volume / p1,
      correct * 0.60,
      p1 * surface_volume
    ]

    {correct_id, options} = make_options(correct, incorrect, "liters")

    text = [
      "You inflate a balloon on the surface to a volume of #{r1(surface_volume)} liters." <>
        " You then bring your balloon to a dive down to #{r1(submersion)} meters.",
      "What volume does your balloon have at the bottom?"
    ]

    explanation = [
      "Boyle's law states that the product of pressure and volume stays constant," <>
        " as long as the temperature does not change.",
      "Initially, on the surface, this gives you (#{surface_volume} L) * (#{p0} bar)" <>
        " = (#{r2(surface_volume * p0)} L * bar).",
      "When you are at the bottom, the surrounding pressure is #{r2(p1)} bar" <>
        " (1 bar from the atmosphere, plus #{r2(p1 - p0)} from the sea water).",
      "Hence, the new volume becomes (#{r2(surface_volume * p0)} L * bar) / (#{r2(p1)} bar)" <>
        " = #{r2(v1)} L."
    ]

    %{
      text: text,
      explanation: explanation,
      options: options,
      correct: correct_id
    }
  end
end
