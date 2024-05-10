defmodule EtWeb.TenderLive do
  use EtWeb, :live_view

  alias Phoenix.LiveView.JS

  def mount(_params, session, socket) do
    question = question()

    socket =
      socket
      |> assign(:student_id, Map.get(session, "student_id"))
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

    :timer.send_after(3000, self(), :clear)

    {:noreply, socket}
  end

  def handle_info(:clear, socket) do
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
    <div class="text-lg mb-8">
      <p :for={paragraph <- @question}>
        <%= paragraph %>
      </p>
    </div>

    <div class="grid gap-4 grid-cols-2 my-10 mx-6">
      <%= for option <- @options do %>
        <.alternative number={option.id} disabled={@answer != nil} colors={option.colors}>
          <%= option.text %>
        </.alternative>
      <% end %>
    </div>

    <div class="flex flex-row justify-between mb-4">
      <button
        phx-click={toggle_explanation()}
        class="border border-slate-900 p-2 w-2/5 text-center rounded-md"
      >
        <span id="ShowExplanation" class="hidden">
          Show explanation <.icon name="hero-chevron-down" />
        </span>
        <span id="HideExplanation">
          Hide explanation <.icon name="hero-chevron-up" />
        </span>
      </button>

      <.link patch={~p"/practice"} class="border border-slate-900 p-2 w-2/5 text-center rounded-md">
        Next question <.icon name="hero-chevron-right" />
      </.link>
    </div>

    <div class="bg-slate-300" id="Explanation">
      <p :for={paragraph <- @explanation}>
        <%= paragraph %>
      </p>
    </div>
    """
  end

  def toggle_explanation do
    JS.toggle(
      to: "#Explanation",
      in: {
        "ease-in-out duration-300",
        "translate-y-full",
        "translate-y-0"
      },
      out: {
        "ease-in-out duration-300",
        "translate-y-0",
        "translate-y-full"
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
        "What volume does it have at 10 meters submersion?"
      ],
      options: make_options(),
      correct: 1,
      explanation: [
        "Boyle's law states that the product of pressure and volume stays constant given constant temperature"
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
    Map.put(option, :colors, "text-slate-900 border-slate-500 bg-slate-50")
  end

  defp color_option(option, answer) do
    colors =
      cond do
        option.correct? && option.id == answer ->
          "text-green-600 border-green-600 bg-green-100"

        option.id == answer ->
          "text-pink-600 border-pink-600 bg-pink-100"

        true ->
          "text-slate-500 border-slate-300 bg-slate-100"
      end

    Map.put(option, :colors, colors)
  end

  defp enumerate(sequence), do: Enum.zip(0..Enum.count(sequence), sequence)
end
