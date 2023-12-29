defmodule Day21 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 21 Step Counter
  https://adventofcode.com/2023/day/21
  """
  require FileHelper

  @doc """
    Part 1: Calculate the number of valid areas (. not #) reached from a point for an exact number of steps
    Part 2: Calculate the areas if step count is larger and map repeats infinitely in every direction
  """
  def solve(filename, max_steps) do
    farm = FileHelper.read_2d_array(filename)

    occupied = [find_start(farm)]
    visited = %{even: MapSet.new(), odd: MapSet.new()}

    {_occupied, visited} = step(farm, 1, occupied, visited, max_steps)

    result = if rem(max_steps, 2) == 0, do: visited[:even], else: visited[:odd]

    MapSet.to_list(result)
    |> print_result(farm)

    Enum.count(result)
  end

  defp step(_, count, occupied, visited, max) when count > max, do: {occupied, visited}

  defp step(farm, count, occupied, visited, max) do
    current_is_even = rem(count, 2) == 0

    next_steps =
      Enum.reduce(occupied, [], fn {x, y}, acc ->
        # North, East, South, West of {x,y}
        valid_next =
          [{x, y - 1}, {x + 1, y}, {x, y + 1}, {x - 1, y}]
          |> Enum.filter(fn {dx, dy} ->
            valid_step?(farm, {dx, dy}, visited, current_is_even)
          end)

        [valid_next | acc]
      end)
      |> List.flatten()
      |> Enum.uniq()

    visited =
      Enum.reduce(next_steps, visited, fn {x, y}, acc ->
        updated_visited(acc, {x, y}, current_is_even)
      end)

    step(farm, count + 1, next_steps, visited, max)
  end

  defp updated_visited(visited, {x, y}, is_even) do
    if is_even do
      %{even: MapSet.put(visited[:even], {x, y}), odd: visited[:odd]}
    else
      %{even: visited[:even], odd: MapSet.put(visited[:odd], {x, y})}
    end
  end

  defp valid_step?(farm, {x, y}, visited, is_even) do
    if is_even do
      valid?(farm, visited[:even], {x, y})
    else
      valid?(farm, visited[:odd], {x, y})
    end
  end

  def valid?(farm, visited_set, {x, y}) do
    if MapSet.member?(visited_set, {x, y}) do
      false
    else
      not_rock?(farm, {x, y})
    end
  end

  defp not_rock?(farm, {x, y}) do
    width = Enum.count(farm)
    height = Enum.count(Enum.at(farm, 0))
    # Use modulo (remainder) of pos & size to wrap around if out of bounds
    dx = rem(x, width)
    dy = rem(y, height)
    Enum.at(farm, dx) |> Enum.at(dy) != "#"
  end

  defp find_start(farm) do
    {start_row, start_row_index} =
      Enum.with_index(farm)
      |> Enum.find(fn {line, _i} -> Enum.member?(line, "S") end)

    start_col_index = Enum.find_index(start_row, fn x -> x == "S" end)
    {start_row_index, start_col_index}
  end

  defp print_result(occupied, farm) do
    Enum.with_index(farm)
    |> Enum.map(fn {line, x} ->
      Enum.with_index(line)
      |> Enum.map(fn {el, y} ->
        if Enum.member?(occupied, {x, y}) do
          IO.write("O")
        else
          IO.write(el)
        end
      end)

      IO.write("\n")
    end)
  end
end

filename = "#{File.cwd!()}/files/day_21_input.txt"
result = Day21.solve(filename, 64)
IO.puts("Part 1: #{result}")

# filename = "#{File.cwd!()}/files/day_21_input.txt"
# result = Day21.solve(filename, 26501365)
# IO.puts("Part 2: #{result}")
