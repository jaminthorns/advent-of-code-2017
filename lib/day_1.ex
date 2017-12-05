defmodule Day1 do
  @moduledoc """
  https://adventofcode.com/2017/day/1

  --- Day 1: Inverse Captcha ---

  The night before Christmas, one of Santa's Elves calls you in a panic. "The
  printer's broken! We can't print the _Naughty or Nice List_!" By the time you
  make it to sub-basement 17, there are only a few minutes until midnight. "We
  have a big problem," she says; "there must be almost _fifty_ bugs in this
  system, but nothing else can print The List. Stand in this square, quick!
  There's no time to explain; if you can convince them to pay you in _stars_,
  you'll be able to--" She pulls a lever and the world goes blurry.

  When your eyes can focus again, everything seems a lot more pixelated than
  before. She must have sent you inside the computer! You check the system
  clock: _25 milliseconds_ until midnight. With that much time, you should be
  able to collect all _fifty stars_ by December 25th.

  Collect stars by solving puzzles. Two puzzles will be made available on each
  day millisecond in the advent calendar; the second puzzle is unlocked when you
  complete the first. Each puzzle grants _one star_. Good luck!

  You're standing in a room with "digitization quarantine" written in LEDs along
  one wall. The only door is locked, but it includes a small interface.
  "Restricted Area - Strictly No Digitized Users Allowed."

  It goes on to explain that you may only leave by solving a
  [captcha](https://en.wikipedia.org/wiki/CAPTCHA) to prove you're _not_ a
  human. Apparently, you only get one millisecond to solve the captcha: too fast
  for a normal human, but it feels like hours to you.

  The captcha requires you to review a sequence of digits (your puzzle input)
  and find the _sum_ of all digits that match the _next_ digit in the list. The
  list is circular, so the digit after the last digit is the _first_ digit in
  the list.

  For example:

  * `1122` produces a sum of `3` (`1` + `2`) because the first digit (`1`)
    matches the second digit and the third digit (`2`) matches the fourth digit.

    iex> Day1.solve_part_1("1122")
    3

  * `1111` produces `4` because each digit (all `1`) matches the next.

    iex> Day1.solve_part_1("1111")
    4

  * `1234` produces `0` because no digit matches the next.

    iex> Day1.solve_part_1("1234")
    0

  * `91212129` produces `9` because the only digit that matches the next one is
    the last digit, `9`.

    iex> Day1.solve_part_1("91212129")
    9

  _What is the solution_ to your captcha?

  --- Part Two ---

  You notice a progress bar that jumps to 50% completion. Apparently, the door
  isn't yet satisfied, but it did emit a _star_ as encouragement. The
  instructions change:

  Now, instead of considering the _next_ digit, it wants you to consider the
  digit _halfway around_ the circular list. That is, if your list contains `10`
  items, only include a digit in your sum if the digit `10/2 = 5` steps forward
  matches it. Fortunately, your list has an even number of elements.

  For example:

  * `1212` produces `6`: the list contains `4` items, and all four digits match
    the digit `2` items ahead.

    iex> Day1.solve_part_2("1212")
    6

  * `1221` produces `0`, because every comparison is between a `1` and a `2`.

    iex> Day1.solve_part_2("1221")
    0

  * `123425` produces `4`, because both `2`s match each other, but no other
    digit has a match.

    iex> Day1.solve_part_2("123425")
    4

  * `123123` produces `12`.

    iex> Day1.solve_part_2("123123")
    12

  * `12131415` produces `4`.

    iex> Day1.solve_part_2("12131415")
    4

  _What is the solution_ to your new captcha?
  """

  @doc """
  Solve part 1 of day 1's puzzle.
  """
  def solve_part_1(input) do
    input
    |> get_digits
    |> sum_matching_digits(1)
  end

  @doc """
  Solve part 2 of day 1's puzzle.
  """
  def solve_part_2(input) do
    digits = get_digits(input)
    distance = digits |> length |> div(2)

    sum_matching_digits(digits, distance)
  end

  defp get_digits(input) do
    input
    |> String.graphemes
    |> Enum.map(&String.to_integer/1)
  end

  defp sum_matching_digits(digits, distance) do
    digits
    |> Stream.zip(rotate(digits, distance))
    |> Stream.filter(fn {current, match} -> current == match end)
    |> Stream.map(fn {current, _match} -> current end)
    |> Enum.sum
  end

  defp rotate(enumerable, count) do
    {right, left} = Enum.split(enumerable, count)
    left ++ right
  end
end
