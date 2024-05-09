defmodule EtWeb.TenderLive do
  use EtWeb, :live_view

  def mount(_params, session, socket) do
    question = question()

    socket =
      socket
      |> assign(:student_id, Map.get(session, "student_id"))
      |> assign(:question, question.text)
      |> assign(:alternatives, question.alternatives)
      |> assign(:answer, nil)

    {:ok, socket}
  end

  def handle_event("submit", %{"value" => value}, socket) do
    {answer, ""} = Integer.parse(value)

    alternatives =
      socket.assigns.alternatives
      |> Enum.map(&color_alternative(&1, answer))

    socket =
      socket
      |> assign(:answer, answer)
      |> assign(:alternatives, alternatives)

    :timer.send_after(3000, self(), :clear)

    {:noreply, socket}
  end

  def handle_info(:clear, socket) do
    alternatives =
      socket.assigns.alternatives
      |> Enum.map(&color_alternative(&1, nil))

    socket =
      socket
      |> assign(:answer, nil)
      |> assign(:alternatives, alternatives)

    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div class="text-lg mb-8">
      <p :for={paragraph <- @question}>
        <%= paragraph %>
      </p>
    </div>

    <div class="grid gap-4 grid-cols-2 m-6">
      <%= for option <- @alternatives do %>
        <.alternative number={option.id} active={is_nil(@answer)} colors={option.colors}>
          <%= option.text %>
        </.alternative>
      <% end %>
    </div>
    """
  end

  attr :active, :boolean, default: true
  attr :number, :integer, required: true
  attr :colors, :string, required: true

  slot :inner_block, required: true

  def alternative(assigns) do
    ~H"""
    <button
      phx-click="submit"
      value={@number}
      disabled={!@active}
      class={[
        "border rounded p-4 relative",
        @colors
      ]}
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
      alternatives: make_alternatives(),
      correct: 1,
      explanation: [
        "Boyle's law states that the product of pressure and volume stays constant given constant temperature"
      ]
    }
  end

  def make_alternatives(_correct \\ nil, _incorrect \\ nil) do
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
    |> Enum.map(&color_alternative(&1, nil))
  end

  defp color_alternative(alternative, nil) do
    Map.put(alternative, :colors, "text-slate-900 border-slate-500 bg-slate-50")
  end

  defp color_alternative(alternative, answer) do
    colors =
      cond do
        alternative.correct? && alternative.id == answer ->
          "text-green-600 border-green-600 bg-green-100"

        alternative.id == answer ->
          "text-pink-600 border-pink-600 bg-pink-100"

        true ->
          "text-slate-500 border-slate-300 bg-slate-100"
      end

    Map.put(alternative, :colors, colors)
  end

  defp enumerate(sequence), do: Enum.zip(0..Enum.count(sequence), sequence)
end
