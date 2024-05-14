defmodule Et.Quiz.Dalton do
  import Et.Quiz.Utils

  def question do
    template =
      [
        :pp_o2_air,
        :pp_n2_nitrox,
        :trimix_remove_helium,
        :imca_max_depth
      ]
      |> Enum.random()

    apply(__MODULE__, template, [])
  end

  def pp_o2_air do
    p = rand_range(220, 310, 10)

    r_o2 = 0.21
    pp_o2 = r_o2 * p

    correct = pp_o2

    incorrect = [
      (1.0 - r_o2) * p,
      p,
      2.1 * pp_o2
    ]

    {correct_id, options} = make_options(correct, incorrect, "bar")

    text = [
      "You have regular air on your bailout bottle, which has a pressure of #{r0(p)}.",
      "What is the partial pressure of oxygen on your bottle?"
    ]

    explanation = [
      "Dalton's law states that the sum of partial pressures in a gas is equal to its total pressure.",
      "In regular air, we have about 21% oxygen and 79% nitrogen.",
      "Hence, the partial pressure of oxygen is (#{r2(p)} bar) * (#{r2(r_o2)}) = #{r2(pp_o2)} bar."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end

  def pp_n2_nitrox do
    ean = rand_range(28, 36)
    p = rand_range(230, 300, 10)

    r_n2 = 1.0 - ean / 100.0
    pp_n2 = r_n2 * p

    correct = pp_n2

    incorrect = [
      (1.0 - r_n2) * p,
      p,
      1.6 * pp_n2
    ]

    {correct_id, options} = make_options(correct, incorrect, "bar")

    text = [
      "You have a bottle of EAN#{round(ean)} at #{r0(p)} bar.",
      "What is the partial pressure of nitrogen on the bottle?"
    ]

    explanation = [
      "Dalton's law states that the sum of partial pressures in a gas is equal to its total pressure.",
      "EAN#{round(ean)} stands for <em>Enriched Air Nitrox #{ean}%</em>, which means that #{ean}% of the gas" <>
        " is pure oxygen.",
      "This means that the percentage of nitrogen on the bottle is (100% - #{ean}%) = #{100 - ean}%.",
      "The partial pressure of nitrogen is then (#{r2(p)} bar) * (#{r2(r_n2)}) = #{r2(pp_n2)} bar."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end

  def trimix_remove_helium do
    o2 = rand_range(2, 12)
    he = rand_range(22, 68)
    n2 = 100 - o2 - he

    p = rand_range(140, 310, 10)

    pp_o2 = p * (o2 / 100.0)
    pp_he = p * (he / 100.0)
    pp_n2 = p * (n2 / 100.0)

    correct = p - pp_he

    incorrect = [
      p - pp_o2,
      p * 0.5,
      p
    ]

    {correct_id, options} = make_options(correct, incorrect, "bar")

    text = [
      "You have a bottle containing trimix at #{r0(p)} bar.",
      "The gas consists of #{r1(o2)}% oxygen, #{r1(n2)}% nitrogen, and #{r1(he)}% helium.",
      "You now remove all the helium from the bottle, without touching the oxygen or nitrogen.",
      "What is the new pressure in the bottle?"
    ]

    explanation = [
      "Dalton's law states that the sum of partial pressures in a gas is equal to its total pressure.",
      "Initially, your bottle contains #{r2(pp_o2)} bar of oxygen, #{r2(pp_n2)} bar of nitrogen, and" <>
        " #{r2(pp_he)} bar of helium gas.",
      "When you remove the helium, you are left with only the partial pressures of oxygen and nitrogen," <>
        " totalling #{r2(p - pp_he)} bar."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end

  def imca_max_depth do
    ean = rand_range(28, 36)
    r_o2 = ean / 100.0

    imca_max_pp_o2 = 1.4

    p_max = imca_max_pp_o2 / r_o2
    depth_max = (p_max - 1.0) * 10.0

    correct = depth_max

    incorrect = [
      1.6 / r_o2,
      50.0,
      imca_max_pp_o2 / (1.0 - r_o2)
    ]

    {correct_id, options} = make_options(correct, incorrect, "m")

    text = [
      "Your breathing gas is EAN#{round(ean)}.",
      "What is the deepest you can go, according to IMCA guidelines?"
    ]

    explanation = [
      "IMCA (the <em>International Marine Contractors Association</em>) recommends a maximum partial pressure" <>
        " of oxygen of #{r1(imca_max_pp_o2)} bar.",
      "EAN#{round(ean)} stands for <em>Enriched Air Nitrox #{ean}%</em>, meaning that #{ean}% of the gas" <>
        " mixture is pure oxygen gas.",
      "Dalton's law states that the sum of partial pressures in a gas is equal to its total pressure.",
      "Hence, we must find the total pressure at which the partial pressure of oxygen becomes" <>
        " #{r1(imca_max_pp_o2)} bar: (#{r1(imca_max_pp_o2)} bar) / (#{r2(r_o2)}) = #{r2(p_max)} bar.",
      "This translates to a depth of (#{r2(p_max)} - 1.00) * 10.0 = #{r2(depth_max)} meters."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end
end
