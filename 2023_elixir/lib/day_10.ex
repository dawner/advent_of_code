defmodule Day10 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 10
  https://adventofcode.com/2023/day/10
  """

  @doc """
    Part 1: Find the halfway point of the continual loop from 'S'
    Part 2: TODO
  """
  def solve(:part_1, filename) do
    pipemap =
      filename
      |> File.stream!()
      |> Stream.map(fn line ->
        String.trim(line)
        |> String.split("", trim: true)
      end)
      |> Enum.to_list()

    start_position =
      pipemap
      |> Enum.with_index()
      |> Enum.reduce_while(nil, fn {row, row_index}, _acc ->
        case Enum.find_index(row, &(&1 == "S")) do
          nil -> {:cont, nil}
          col_index -> {:halt, {row_index, col_index}}
        end
      end)

    route_length = find_route(pipemap, start_position)
    route_length / 2
  end

  # def solve(:part_2, filename) do
  # end

  def find_route(pipemap, {row, col}) do
    [:north, :east, :south, :west]
    |> Enum.reduce_while(nil, fn dir, acc ->
      size = loop_length(dir, pipemap, position(dir, {row, col}), 0)
      if size > 0, do: {:halt, size}, else: {:cont, acc}
    end)
  end

  defp loop_length(direction, pipemap, {row, col}, acc) do
    element = Enum.at(pipemap, row) |> Enum.at(col)

    case next?(direction, element) do
      nil -> 0
      :finish -> acc + 1
      next -> loop_length(next, pipemap, position(next, {row, col}), acc + 1)
    end
  end

  defp position(:north, {row, col}), do: {row - 1, col}
  defp position(:east, {row, col}), do: {row, col + 1}
  defp position(:south, {row, col}), do: {row + 1, col}
  defp position(:west, {row, col}), do: {row, col - 1}

  def next?(_, "."), do: nil
  def next?(_, "S"), do: :finish

  def next?(:north, "|"), do: :north
  def next?(:north, "-"), do: nil
  def next?(:north, "L"), do: nil
  def next?(:north, "J"), do: nil
  def next?(:north, "7"), do: :west
  def next?(:north, "F"), do: :east

  def next?(:east, "|"), do: nil
  def next?(:east, "-"), do: :east
  def next?(:east, "L"), do: nil
  def next?(:east, "J"), do: :north
  def next?(:east, "7"), do: :south
  def next?(:east, "F"), do: nil

  def next?(:south, "|"), do: :south
  def next?(:south, "-"), do: nil
  def next?(:south, "L"), do: :east
  def next?(:south, "J"), do: :west
  def next?(:south, "7"), do: nil
  def next?(:south, "F"), do: nil

  def next?(:west, "|"), do: nil
  def next?(:west, "-"), do: :west
  def next?(:west, "L"), do: :north
  def next?(:west, "J"), do: nil
  def next?(:west, "7"), do: nil
  def next?(:west, "F"), do: :south
end

filename = "#{File.cwd!()}/files/day_10_input.txt"
result = Day10.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

# result = Day10.solve(:part_2, filename)
# IO.puts("Part 2: #{result}")
