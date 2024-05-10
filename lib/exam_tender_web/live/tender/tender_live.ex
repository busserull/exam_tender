defmodule EtWeb.TenderLive do
  use EtWeb, :live_view

  alias Phoenix.LiveView.JS

  def mount(_params, session, socket) do
    question = question()

    socket =
      socket
      |> assign(:student_id, Map.get(session, "student_id"))
      |> assign(:count, %{at: 1, of: 5})
      |> assign(:question, question.text)
      |> assign(:explanation, question.explanation)
      |> assign(:options, question.options)
      |> assign(:answer, nil)

    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end

  def handle_event("submit", %{"value" => value}, socket) do
    {answer, ""} = Integer.parse(value)

    options =
      socket.assigns.options
      |> Enum.map(&color_option(&1, answer))

    socket =
      socket
      |> assign(:answer, answer)
      |> assign(:options, options)

    {:noreply, socket}
  end

  def handle_event("clear", _params, socket) do
    options =
      socket.assigns.options
      |> Enum.map(&color_option(&1, nil))

    socket =
      socket
      |> assign(:answer, nil)
      |> assign(:options, options)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <section>
      <p class="text-sm text-stone-500">
        Question <%= @count.at %>/<%= @count.of %>
      </p>

      <div class="mt-4 mb-2">
        <p :for={paragraph <- @question} class="text-lg text-stone-900 leading-relaxed">
          <%= paragraph %>
        </p>
      </div>
    </section>

    <div class="grid gap-4 grid-cols-2 my-10 mx-6">
      <%= for option <- @options do %>
        <.alternative number={option.id} disabled={@answer != nil} colors={option.colors}>
          <%= option.text %>
        </.alternative>
      <% end %>
    </div>

    <section :if={@answer != nil}>
      <div class="flex flex-row justify-around mb-4 mx-6">
        <button
          phx-click={toggle_explanation()}
          class="rounded-full p-2 w-2/5 text-center text-sky-600 border border-sky-600 hover:text-sky-500 hover:border-sky-500 transition-colors font-medium tracking-wide"
        >
          <span id="ShowExplanation">
            Show explanation
          </span>
          <span id="HideExplanation" class="hidden">
            Hide explanation
          </span>
        </button>

        <button
          phx-click="clear"
          class="rounded-full p-2 w-2/5 text-center text-white border border-sky-600 hover:border-sky-500 hover:bg-sky-500 transition-colors font-medium tracking-wide bg-sky-600"
        >
          Next question <.icon name="hero-chevron-right" />
        </button>
      </div>

      <div id="Explanation" class="mx-6 mt-6 leading-loose hidden">
        <p :for={paragraph <- @explanation} class="text-stone-800">
          <%= paragraph %>
        </p>
      </div>
    </section>
    """
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
  attr :rest, :global

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
    [
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
    |> Enum.map(&color_option(&1, nil))
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
