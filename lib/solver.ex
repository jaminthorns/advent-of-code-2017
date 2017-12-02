defmodule Solver do
  @doc """
  Solve a puzzle for a given day.

  Calls the `solve/1` function on the `DayN` module using the input from the
  `inputs/day_n.txt` file.
  """
  def solve(day) do
    day
    |> get_input
    |> call_solve(day)
  end

  defp get_input(day) do
    "inputs/day_#{day}.txt"
    |> File.read!
    |> String.trim
  end

  defp call_solve(input, day) do
    "Elixir.Day#{day}"
    |> String.to_existing_atom
    |> apply(:solve, [input])
  end
end
