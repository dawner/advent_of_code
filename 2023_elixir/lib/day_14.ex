defmodule Day14 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 14
  https://adventofcode.com/2023/day/14
  """

  @doc """
    Part 1: Move all rocks ("O") to north side of grid and calculate total load
    Part 2: Tilt for a "cycle" (N, E, S, W) 1 million and calculate load at end
  """
  def solve(:part_1, filename) do
    FileHelper.read_2d_array(filename)
    |> tilt()
    |> Enum.with_index()
    |> Enum.map(fn {line, index} -> Enum.count(line, &(&1 == "O")) * (index + 1) end)
    |> Enum.sum()
  end

  def solve(:part_2, filename) do
    map = FileHelper.read_2d_array(filename)
    cycles = 1_000_000_000

    {loop_start, loop_end, history} =
      Enum.reduce_while(0..cycles, {map, []}, fn i, {current, history} ->
        r = tilt_cycle(current)

        if Enum.member?(history, r) do
          # We've already seen this result, pattern is repeating so break
          history = Enum.reverse(history)
          loop_start = Enum.find_index(history, fn x -> x == r end)
          {:halt, {loop_start, i, history}}
        else
          {:cont, {r, [r | history]}}
        end
      end)

    # Find the remainder if cycles/lenght of loop
    position_in_loop = rem(cycles - loop_end - 1, loop_end - loop_start)

    Enum.at(history, loop_start + position_in_loop)
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.map(fn {line, index} -> Enum.count(line, &(&1 == "O")) * (index + 1) end)
    |> Enum.sum()
  end

  defp tilt_cycle(map) do
    # North
    tilt(map)
    |> Enum.reverse()

    # East
    |> Enum.zip_with(&Function.identity/1)
    |> tilt()
    |> Enum.reverse()
    |> Enum.zip_with(&Function.identity/1)

    # South
    |> Enum.reverse()
    |> tilt()

    # West
    |> Enum.zip_with(&Function.identity/1)
    |> Enum.reverse()
    |> tilt()
    |> Enum.zip_with(&Function.identity/1)
  end

  defp tilt([hd | tl]) do
    Enum.with_index(tl)
    |> Enum.reduce([hd], fn {line, index}, acc ->
      move_rocks(line, index + 1, acc)
    end)
  end

  defp move_rocks(line, 0, []) do
    [line]
  end

  defp move_rocks(line, row_index, result) do
    {new_line, [hd | tl]} =
      Enum.with_index(line)
      |> Enum.reduce({line, result}, fn {x, i}, {line, [hd | tl]} = acc ->
        if x == "O" && Enum.at(hd, i) == "." do
          hd = List.replace_at(hd, i, "O")
          line = List.replace_at(line, i, ".")

          {line, [hd | tl]}
        else
          acc
        end
      end)

    list =
      if new_line != line do
        move_rocks(hd, row_index - 1, tl)
      else
        [hd | tl]
      end

    [new_line | list]
  end
end

filename = "#{File.cwd!()}/files/day_14_input.txt"
result = Day14.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day14.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
