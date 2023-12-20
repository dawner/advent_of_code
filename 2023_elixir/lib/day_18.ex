defmodule Day18 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 18
  https://adventofcode.com/2023/day/18
  """

  @doc """
    Part 1:
  """
  def solve(:part_1, filename) do
    filename
    |> File.stream!()
    |> Stream.map(fn line ->
      [_, dir, num] = Regex.run(~r/([RLUD])\s([0-9]+)\s\(#[0-9a-z]{6}\)/, line)
      {dir, String.to_integer(num)}
    end)
    |> Enum.to_list()
    |> calculate_area()
  end

  def solve(:part_2, filename) do
    filename
    |> File.stream!()
    |> Stream.map(fn line ->
      [_, hex_num, enc_dir] =
        Regex.run(~r/[RLUD]\s[0-9]+\s\(#([0-9a-z]{5})([0-9a-z]){1}\)/, line)

      {num, ""} = Integer.parse(hex_num, 16)
      {hex_to_dir(enc_dir), num}
    end)
    |> Enum.to_list()
    |> calculate_area()
  end

  defp calculate_area(instructions) do
    boundary = Enum.map(instructions, fn {_, num} -> num end) |> Enum.sum()
    points = collect_points({0, 0}, instructions, []) |> Enum.reverse()
    area = area_from_points(points)
    interior = interior(area, boundary)
    boundary + interior
  end

  # Shoelace formula
  defp area_from_points(points) do
    Enum.chunk_every(points, 2, 1, :discard)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] -> x1 * y2 - x2 * y1 end)
    |> Enum.sum()
    |> Kernel./(2)
    |> abs()
  end

  # Picks algorithm
  defp interior(area, boundary) do
    area + 1 - boundary / 2
  end

  defp collect_points(_current, [], points), do: points

  defp collect_points({x, y}, [{dir, num} | instructions], points) do
    next = next_point({x, y}, dir, num)
    collect_points(next, instructions, [next | points])
  end

  defp next_point({x, y}, dir, num) do
    case dir do
      "R" -> {x, y + num}
      "L" -> {x, y - num}
      "U" -> {x - num, y}
      "D" -> {x + num, y}
    end
  end

  defp hex_to_dir(num) do
    case num do
      "0" -> "R"
      "1" -> "D"
      "2" -> "L"
      "3" -> "U"
    end
  end
end

filename = "#{File.cwd!()}/files/day_18_input.txt"
result = Day18.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day18.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
