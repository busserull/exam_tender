defmodule Et.Quiz do
  alias Et.Quiz.Boyle

  def topics do
    %{
      0 => {Boyle, "Boyle's law"}
    }
  end

  def question do
    Boyle.question()
  end
end
