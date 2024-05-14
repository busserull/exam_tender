defmodule Et.Quiz.Archimedes do
  import Et.Quiz.Utils

  def question do
    cube_ship()
  end

  def cube_ship do
    l = rand_range(8, 12, 0.5)
    w = rand_range(4, 6, 0.5)
    depth = rand_range(0.6, 1.6, 0.1)

    v = l * w * depth
    m = v

    correct = m

    incorrect = [
      0.85 * m,
      depth * depth * l * 1000.0,
      2.13 * m
    ]

    {correct_id, options} = make_options(correct, incorrect, "tonnes")

    text = [
      "A square barge measuring #{r1(l)} meters long by #{r1(w)} meters wide is sitting" <>
        " #{r1(depth)} meters in the water.",
      "You can assume that the density of water is 1000 kg/m<sup>3</sup>.",
      "What is the mass of the barge?"
    ]

    explanation = [
      "Archimedes' principle states that an object's buoyant force is equal to the weight" <>
        " of the water it displaces.",
      "The volume of the barge that sits under the water line is (#{r1(l)} m) * (#{r1(w)} m)" <>
        " * (#{r1(depth)} m) = (#{r2(v)} m<sup>3</sup>).",
      "It displaces water with a density of 1000 kg/m<sup>3</sup>, which means that it's" <>
        " mass is #{r2(1000.0 * m)} kg, or #{r2(m)} metric tonnes."
    ]

    %{
      text: text,
      explanation: explanation,
      correct: correct_id,
      options: options
    }
  end
end
