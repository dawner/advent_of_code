defmodule Day13 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 13
  https://adventofcode.com/2023/day/13
  """

  @doc """
    Part 1: Find the point of reflection in a grid
    Part 2: Find the point of reflection with one row "smudged" to change a single character
  """
  def solve(:part_1, filename) do
    calculate(filename, false)
  end

  def solve(:part_2, filename) do
    calculate(filename, true)
  end

  defp calculate(filename, smudge) do
    read_file(filename)
    |> Enum.with_index()
    |> Enum.map(fn {{hor, vert}, i} ->
      h = reflection_index(hor, smudge)
      v = reflection_index(vert, smudge)
      if h == nil && v == nil, do: raise("No reflection found")
      if h, do: 100 * (h + 1), else: v + 1
    end)
    |> Enum.sum()
  end

  defp reflection_index(rows, smudge) do
    Enum.chunk_every(rows, 2, 1, :discard)
    |> Enum.with_index()
    |> Enum.find_index(fn {[a, b], i} ->
      reflected?(rows, i, 0, smudge, nil)
    end)
  end

  defp reflected?(rows, start_row, reflect_step, smudge, smudged) do
    if start_row - reflect_step < 0 || start_row + 1 + reflect_step >= length(rows) do
      # Beyond boundaries of rows, so must have reflected
      if smudge, do: smudged, else: true
    else
      row1 = Enum.at(rows, start_row - reflect_step)
      row2 = Enum.at(rows, start_row + 1 + reflect_step)

      if smudge && smudged == nil do
        check_smudged(rows, row1, row2, start_row, reflect_step)
      else
        if row1 == row2 do
          reflected?(rows, start_row, reflect_step + 1, smudge, smudged)
        else
          false
        end
      end
    end
  end

  defp check_smudged(rows, row1, row2, start_row, reflect_step) do
    smudged =
      Enum.find(0..(length(row1) - 1), fn i ->
        invert_row(rows, row1, row2, i, start_row, reflect_step) ||
          invert_row(rows, row2, row1, i, start_row, reflect_step)
      end)

    if smudged == nil && row1 == row2 do
      reflected?(rows, start_row, reflect_step + 1, true, nil)
    else
      smudged
    end
  end

  defp invert_row(rows, row1, row2, i, start_row_index, reflect_step) do
    new_symbol = Enum.at(row1, i) |> invert()
    new_row = List.replace_at(row1, i, new_symbol)

    if new_row == row2 do
      reflected?(rows, start_row_index, reflect_step + 1, true, true)
    else
      false
    end
  end

  defp invert("#"), do: "."
  defp invert("."), do: "#"

  defp read_file(filename) do
    chunk_fun = fn line, acc ->
      if line == "\n" do
        {:cont, acc, []}
      else
        parsed =
          line
          |> String.trim()
          |> String.split("", trim: true)

        {:cont, [parsed | acc]}
      end
    end

    after_fun = fn
      [] -> {:cont, []}
      acc -> {:cont, acc, []}
    end

    filename
    |> File.stream!()
    |> Stream.chunk_while([], chunk_fun, after_fun)
    |> Enum.map(fn horizontal_rows ->
      horizontal_rows =
        Enum.reverse(horizontal_rows)

      # Transpose to find expansion columns
      verical_rows =
        Enum.zip_with(horizontal_rows, &Function.identity/1)

      {horizontal_rows, verical_rows}
    end)
  end
end

filename = "#{File.cwd!()}/files/day_13_input.txt"
result = Day13.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day13.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
