defmodule EtWeb.TenderLive do
  use EtWeb, :live_view

  alias Et.Quiz

  alias Phoenix.LiveView.JS

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def mount(_params, session, socket) do
    socket =
      socket
      |> assign(:student_id, Map.get(session, "student_id"))
      |> assign(:set_complete, false)
      |> assign(:count_at, 1)
      |> assign(:count_of, 5)
      |> assign(:questions_asked, 0)
      |> assign(:last_answer_correct, nil)
      |> assign_new_question()

    {:ok, socket}
  end

  defp assign_new_question(socket) do
    question = Quiz.question()

    socket
    |> maybe_update_count()
    |> update(:questions_asked, &(&1 + 1))
    |> assign(:question, Enum.map(question.text, &{:safe, &1}))
    |> assign(:explanation, question.explanation)
    |> assign(:options, color_options(question.options))
    |> assign(:answer, nil)
  end

  defp maybe_update_count(socket) do
    if socket.assigns.last_answer_correct do
      update(socket, :count_at, &(&1 + 1))
    else
      socket
    end
  end

  def maybe_complete_set(socket) do
    %{
      last_answer_correct: last_correct,
      count_at: at,
      count_of: of,
      questions_asked: asked
    } = socket.assigns

    accuracy = of / asked

    recommend_retry = accuracy < 0.60

    if last_correct && at == of do
      assign(socket, set_complete: true, recommend_retry: recommend_retry)
    else
      socket
    end
  end

  def handle_event("submit", %{"value" => value}, socket) do
    {answer, ""} = Integer.parse(value)

    answer_correct? =
      socket.assigns.options
      |> Enum.find(&(&1.id == answer))
      |> Map.fetch!(:correct?)

    socket =
      socket
      |> update(:options, &color_options(&1, answer))
      |> assign(:answer, answer)
      |> assign(:last_answer_correct, answer_correct?)
      |> maybe_complete_set()

    {:noreply, socket}
  end

  def handle_event("clear", _params, socket) do
    {:noreply, assign_new_question(socket)}
  end

  def handle_info(:complete_set, socket) do
    accuracy = socket.assigns.count_of / socket.assigns.questions_asked
    {:noreply, assign(socket, set_complete: true, accuracy: accuracy)}
  end

  def toggle_explanation do
    JS.toggle(
      to: "#Explanation",
      in: {
        "ease-in-out duration-300",
        "opacity-0 translate-y-6",
        "opacity-100 translate-y-0"
      },
      out: {
        "ease-in-out duration-300",
        "opacity-100 translate-y-0",
        "opacity-0 translate-y-6"
      },
      time: 300
    )
    |> JS.toggle(to: "#ShowExplanation")
    |> JS.toggle(to: "#HideExplanation")
  end

  attr :number, :integer, required: true
  attr :colors, :string, required: true
  attr :rest, :global, include: ~w(disabled)

  slot :inner_block, required: true

  def alternative(assigns) do
    ~H"""
    <button
      phx-click="submit"
      value={@number}
      class={[
        "border rounded-lg p-4 relative transition-colors duration-200",
        @colors
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </button>
    """
  end

  # Boyle's law
  def question do
    %{
      text: [
        "A balloon at the surface has a volume of 2 liters.",
        "What volume does it have at 10 meters submersion in water?"
      ],
      options: make_options(),
      correct: 1,
      explanation: [
        "Boyle's law states that the product of pressure and volume stays constant given constant temperature." <>
          "At the surface, we have 1 bar of pressure, giving us a product of 2 bar * L." <>
          "At 10 meters of water, we have 1 additional bar of pressure, plus the 1 bar from the atmosphere. Hence, we have a total of 2 bar pressure." <>
          "Divide 2 bar * L by 2 bar, and we get 1 L, which is the balloon's volume when submerged."
      ]
    }
  end

  def make_options(_correct \\ nil, _incorrect \\ nil) do
    options = [
      %{
        text: "6 liters",
        id: 0,
        correct?: false
      },
      %{
        text: "1 liter",
        id: 1,
        correct?: true
      },
      %{
        text: "3 liters",
        id: 2,
        correct?: false
      },
      %{
        text: "2 liters",
        id: 3,
        correct?: false
      }
    ]

    color_options(options, nil)
  end

  defp color_options(options, answer \\ nil) do
    Enum.map(options, &color_option(&1, answer))
  end

  defp color_option(option, nil) do
    Map.put(
      option,
      :colors,
      "text-stone-900 border-stone-500 bg-stone-100 hover:bg-stone-50"
    )
  end

  defp color_option(option, answer) do
    colors =
      cond do
        option.correct? && option.id == answer ->
          "text-green-600 border-green-600 bg-green-100"

        option.id == answer ->
          "text-pink-600 border-pink-600 bg-pink-100"

        true ->
          "text-stone-500 border-stone-300 bg-stone-100"
      end

    Map.put(option, :colors, colors)
  end

  defp enumerate(sequence), do: Enum.zip(0..Enum.count(sequence), sequence)
end
