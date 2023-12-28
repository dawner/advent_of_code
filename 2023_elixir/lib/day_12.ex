defmodule Day12 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 12
  https://adventofcode.com/2023/day/12
  """

  @doc """
    Part 1: Work out all possible arrangements of damaged sprints (#), given unknown sprint locations (?)
    Part 2: As above but with springs "unfolded" x5
  """
  def solve(:part_1, filename) do
    FileHelper.read_2d_array(filename, " ")
    |> Enum.map(fn [line, sizes] ->
      process_line(line, sizes)
    end)
    |> Enum.sum()
  end

  def solve(:part_2, filename) do
    FileHelper.read_2d_array(filename, " ")
    |> Enum.map(fn [line, sizes] ->
      sizes = List.duplicate(sizes, 5) |> Enum.join(",")
      line = List.duplicate(line, 5) |> Enum.join("?")
      process_line(line, sizes)
    end)
    |> Enum.sum()
  end

  def process_line(line, sizes) do
    sizes =
      String.split(sizes, ",")
      |> Enum.map(&String.to_integer/1)

    count(line, sizes)
  end

  defp count("", []), do: 1
  defp count(line, []), do: if(String.contains?(line, "#"), do: 0, else: 1)
  defp count("", _), do: 0

  defp count("." <> line, sizes) do
    count(line, sizes)
  end

  defp count("?" <> tail = line, sizes) do
    {size, remain_sizes} = List.pop_at(sizes, 0)

    if match_group?(line, size) do
      new_line = String.slice(line, size + 1, String.length(line))

      count(new_line, remain_sizes) + count(tail, sizes)
    else
      count(tail, sizes)
    end
  end

  defp count("#" <> _ = line, [size | sizes]) do
    if match_group?(line, size) do
      new_line = String.slice(line, size + 1, String.length(line))
      count(new_line, sizes)
    else
      0
    end
  end

  defp match_group?(line, size) do
    # Ensure string contains a sequential list of "?" or "#",
    # followed by a "?" or a "." to ensure contiguous
    String.match?(line, ~r/^([?|#]{#{size}})([.?]|$)/)
  end
end

filename = "#{File.cwd!()}/files/day_12_input.txt"
result = Day12.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

# TODO make more efficient
# result = Day12.solve(:part_2, filename)
# IO.puts("Part 2: #{result}")
