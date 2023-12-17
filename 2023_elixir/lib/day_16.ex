defmodule Day16 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 16
  https://adventofcode.com/2023/day/16
  """

  @doc """
    Part 1: Follow light beam path and calculate all tiles it "energizes"
    Part 2: Try all possible entry points on edges to find the max number of tiles energized
  """
  def solve(:part_1, filename) do
    {map, edge} = read_map(filename)
    find_route_and_count({0, 0}, :east, map, edge)
  end

  def solve(:part_2, filename) do
    {map, {rows, cols}} = read_map(filename)

    east_start = Enum.map(0..rows, fn row -> {:east, {row, 0}} end)
    west_start = Enum.map(0..rows, fn row -> {:west, {row, cols - 1}} end)
    south_start = Enum.map(0..cols, fn col -> {:south, {0, col}} end)
    north_start = Enum.map(0..cols, fn col -> {:north, {rows - 1, col}} end)

    starting_points = east_start ++ west_start ++ south_start ++ north_start

    {dir, pos} =
      starting_points
      |> Enum.max_by(fn {dir, pos} ->
        find_route_and_count(pos, dir, map, {rows, cols})
      end)

    find_route_and_count(pos, dir, map, {rows, cols})
  end

  defp read_map(filename) do
    map =
      filename
      |> File.stream!()
      |> Stream.map(fn line ->
        String.trim(line)
        |> String.split("", trim: true)
      end)
      |> Enum.to_list()

    {map, {Enum.count(map), Enum.count(Enum.at(map, 0))}}
  end

  defp find_route_and_count(start_pos, start_dir, map, edge) do
    {:ok, path} = LightPath.start_link([])
    find_route(map, start_pos, start_dir, edge, path)

    LightPath.get(path)
    |> Enum.map(fn {_dir, pos} -> pos end)
    |> Enum.uniq()
    |> Enum.count()
  end

  defp find_route(_map, {row, col}, _dir, {rows, cols}, path)
       when row < 0 or col < 0 or row > rows - 1 or col > cols - 1,
       do: path

  defp find_route(map, {row, col}, dir, edge, path) do
    element = Enum.at(map, row) |> Enum.at(col)

    step = {dir, {row, col}}

    if element == nil || LightPath.member?(path, step) do
      path
    else
      LightPath.put(path, step)

      element
      |> next(dir, {row, col})
      |> Enum.map(fn {new_pos, new_dir} ->
        find_route(map, new_pos, new_dir, edge, path)
      end)
    end
  end

  defp next("|", dir, pos) when dir in [:north, :south], do: step(dir, pos)
  defp next("|", dir, pos) when dir in [:east, :west], do: split(:vert, pos)
  defp next("-", dir, pos) when dir in [:north, :south], do: split(:hor, pos)
  defp next("-", dir, pos) when dir in [:east, :west], do: step(dir, pos)
  defp next("\\", :north, pos), do: step(:west, pos)
  defp next("\\", :south, pos), do: step(:east, pos)
  defp next("\\", :east, pos), do: step(:south, pos)
  defp next("\\", :west, pos), do: step(:north, pos)
  defp next("/", :north, pos), do: step(:east, pos)
  defp next("/", :south, pos), do: step(:west, pos)
  defp next("/", :east, pos), do: step(:north, pos)
  defp next("/", :west, pos), do: step(:south, pos)
  defp next(".", dir, pos), do: step(dir, pos)
  defp next(nil, _, _), do: []

  defp split(:vert, {row, col}), do: [{{row - 1, col}, :north}, {{row + 1, col}, :south}]
  defp split(:hor, {row, col}), do: [{{row, col - 1}, :west}, {{row, col + 1}, :east}]

  defp step(:north, {row, col}), do: [{{row - 1, col}, :north}]
  defp step(:east, {row, col}), do: [{{row, col + 1}, :east}]
  defp step(:south, {row, col}), do: [{{row + 1, col}, :south}]
  defp step(:west, {row, col}), do: [{{row, col - 1}, :west}]
end

defmodule LightPath do
  use Agent

  def start_link(_opts) do
    Agent.start_link(fn -> MapSet.new() end)
  end

  def member?(path, key) do
    Agent.get(path, &MapSet.member?(&1, key))
  end

  def put(path, step) do
    Agent.update(path, &MapSet.put(&1, step))
  end

  def get(path) do
    Agent.get(path, &MapSet.to_list(&1))
  end
end

filename = "#{File.cwd!()}/files/day_16_input.txt"
result = Day16.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day16.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
