defmodule Day5 do
  @moduledoc """
  https://adventofcode.com/2017/day/5

  --- Day 5: A Maze of Twisty Trampolines, All Alike ---

  An urgent interrupt arrives from the CPU: it's trapped in a maze of jump
  instructions, and it would like assistance from any programs with spare cycles
  to help find the exit.

  The message includes a list of the offsets for each jump. Jumps are relative:
  `-1` moves to the previous instruction, and `2` skips the next one. Start at
  the first instruction in the list. The goal is to follow the jumps until one
  leads _outside_ the list.

  In addition, these instructions are a little strange; after each jump, the
  offset of that instruction increases by `1`. So, if you come across an offset
  of `3`, you would move three instructions forward, but change it to a `4` for
  the next time it is encountered.

  For example, consider the following list of jump offsets:

  ```
  0
  3
  0
  1
  -3
  ```

  Positive jumps ("forward") move downward; negative jumps move upward. For
  legibility in this example, these offset values will be written all on one
  line, with the current instruction marked in parentheses. The following steps
  would be taken before an exit is found:

  * `(0) 3  0  1  -3 ` - _before_ we have taken any steps.
  * `(1) 3  0  1  -3 ` - jump with offset `0` (that is, don't jump at all).
    Fortunately, the instruction is then incremented to `1`.
  * ` 2 (3) 0  1  -3 ` - step forward because of the instruction we just
    modified. The first instruction is incremented again, now to `2`.
  * ` 2  4  0  1 (-3)` - jump all the way to the end; leave a `4` behind.
  * ` 2 (4) 0  1  -2 ` - go back to where we just were; increment `-3` to `-2`.
  * ` 2  5  0  1  -2 ` - jump `4` steps forward, escaping the maze.

  In this example, the exit is reached in `5` steps.

    iex> Day5.solve_part_1("0
    ...> 3
    ...> 0
    ...> 1
    ...> -3")
    5

  _How many steps_ does it take to reach the exit?

  --- Part Two ---

  Now, the jumps are even stranger: after each jump, if the offset was _three or
  more_, instead _decrease_ it by `1`. Otherwise, increase it by `1` as before.

  Using this rule with the above example, the process now takes `10` steps, and
  the offset values after finding the exit are left as `2 3 2 3 -1`.

    iex> Day5.solve_part_2("0
    ...> 3
    ...> 0
    ...> 1
    ...> -3")
    10

  _How many steps_ does it now take to reach the exit?
  """

  @doc """
  Solve part 1 of day 5's puzzle.
  """
  def solve_part_1(input) do
    input
    |> get_instructions
    |> calculate_jumps(&jump_forward/1)
  end

  @doc """
  Solve part 2 of day 5's puzzle.
  """
  def solve_part_2(input) do
    input
    |> get_instructions
    |> calculate_jumps(&jump_forward_or_backward/1)
  end

  defp get_instructions(input) do
    input
    |> String.split("\n")
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.to_integer/1)
    |> Stream.with_index
    |> Stream.map(fn {a, b} -> {b, a} end)
    |> Enum.into(%{})
  end

  defp calculate_jumps(instructions, next) do
    {instructions, 0}
    |> Stream.iterate(&jump(&1, next))
    |> Stream.take_while(&trapped?/1)
    |> Enum.count
  end

  defp jump({instructions, position}, next) do
    case Map.get(instructions, position) do
      nil -> {instructions, position}
      offset -> {%{instructions | position => next.(offset)}, position + offset}
    end
  end

  defp trapped?({instructions, position}) do
    Map.has_key?(instructions, position)
  end

  defp jump_forward(offset), do: offset + 1

  defp jump_forward_or_backward(offset) when offset >= 3, do: offset - 1
  defp jump_forward_or_backward(offset), do: offset + 1
end
