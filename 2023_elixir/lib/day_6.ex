defmodule Day6 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 6
  https://adventofcode.com/2023/day/6
  """

  @doc """
    Part 1: Reads a file of race data, determines how number ways to beat the record by holding button.
    Returns product of those results per game
    Part 2: Reads a file of a single race data, removing any blanks, then determines how number ways to
    beat the record by holding button.
  """
  def solve(:part_1, filename) do
    [times, distances] = read_file(filename, true)

    Enum.with_index(times)
    |> Enum.map(fn {time, i} ->
      dist = Enum.at(distances, i)
      count_ways_to_win(String.to_integer(time), String.to_integer(dist))
    end)
    |> Enum.product()
  end

  def solve(:part_2, filename) do
    [time, distance] = read_file(filename, false)
    count_ways_to_win(String.to_integer(time), String.to_integer(distance))
  end

  defp count_ways_to_win(time, distance) do
    Enum.filter(1..time, fn x -> (time - x) * x > distance end)
    |> length()
  end

  defp read_file(filename, count_blanks) do
    FileHelper.read_lines(filename)
    |> Enum.map(fn s ->
      content =
        String.split(s, ":", trim: true)
        |> Enum.at(1)

      if count_blanks do
        String.split(content, " ", trim: true)
      else
        String.replace(content, ~r/\s/, "")
      end
    end)
  end
end

filename = "#{File.cwd!()}/files/day_6_input.txt"
result = Day6.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day6.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
