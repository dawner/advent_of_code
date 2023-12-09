defmodule Day9 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 9
  https://adventofcode.com/2023/day/9
  """

  @doc """
    Part 1: Calculate the differences in a sequence down to 0s, to predict next value
    Part 2: Calculate the differences in a sequence down to 0s, to predict previous value
  """
  def solve(:part_1, filename) do
    solve_file(filename, &next_in_history/2)
  end

  def solve(:part_2, filename) do
    solve_file(filename, &prev_in_history/2)
  end

  defp solve_file(filename, post_fn) do
    filename
    |> File.stream!()
    |> Stream.map(fn l -> calculate_line(l, post_fn) end)
    |> Enum.sum()
  end

  defp parse_line(line) do
    String.split(line, " ", trim: true)
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.to_integer/1)
  end

  def calculate_line(line, post_fn) do
    line = parse_line(line)
    execute_line(line, [], post_fn)
  end

  defp execute_line(differences, rows, post_fn) do
    if Enum.all?(differences, &(&1 == 0)) do
      post_fn.(rows, 0)
    else
      differences = Enum.reverse(differences)
      get_differences(differences, [], [differences | rows], post_fn)
    end
  end

  defp get_differences([val1, val2], acc, rows, post_fn),
    do: execute_line([val1 - val2 | acc], rows, post_fn)

  defp get_differences([val1, val2 | line], acc, rows, post_fn) do
    get_differences([val2 | line], [val1 - val2 | acc], rows, post_fn)
  end

  defp prev_in_history([], add), do: add

  defp prev_in_history(rows, add) do
    [head | tail] = rows
    [val | _] = Enum.reverse(head)
    prev_in_history(tail, val - add)
  end

  defp next_in_history([], add), do: add

  defp next_in_history(rows, add) do
    [[val | _] | tail] = rows
    next_in_history(tail, val + add)
  end
end

filename = "#{File.cwd!()}/files/day_9_input.txt"
result = Day9.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day9.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
