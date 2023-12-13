defmodule Day11 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 11
  https://adventofcode.com/2023/day/11
  """

  @doc """
    Part 1: Find sum of the shorest distances between all galaxies (#), accounting for blank line expansion
    Part 2: As above but with expansion x1,000,000
  """
  def solve(filename, expansion) do
    {map, expanded_rows, expanded_cols} = read_file(filename)

    {galaxies, _, _} =
      Enum.with_index(map)
      |> Enum.reduce({%{}, 1, {0, 0}}, fn {row, r}, {coords, i, {row_exp, _}} ->
        row_exp = calc_expansion(expanded_rows, r, row_exp, expansion)

        Enum.with_index(row)
        |> Enum.reduce({coords, i, {row_exp, 0}}, fn {element, c},
                                                     {coords, i, {row_exp, col_exp}} ->
          col_exp = calc_expansion(expanded_cols, c, col_exp, expansion)

          if element == "#" do
            {Map.put(coords, i, {r + row_exp, c + col_exp}), i + 1, {row_exp, col_exp}}
          else
            {coords, i, {row_exp, col_exp}}
          end
        end)
      end)

    find_shortest_paths(galaxies)
    |> Enum.sum()
  end

  defp calc_expansion(expanded_indexs, current_index, current_exp, expansion_multiplier) do
    if Enum.member?(expanded_indexs, current_index) do
      current_exp + 1 * expansion_multiplier - 1
    else
      current_exp
    end
  end

  defp find_shortest_paths(galaxies) do
    keys = Map.keys(galaxies)

    pairs = for x <- 1..length(keys), y <- x..length(keys), x != y, do: {x, y}

    Enum.reduce(pairs, [], fn {k1, k2}, acc ->
      {sx, sy} = Map.get(galaxies, k1)
      {ex, ey} = Map.get(galaxies, k2)
      dis = abs(ex - sx) + abs(ey - sy)
      [dis | acc]
    end)
  end

  defp read_file(filename) do
    {:ok, file_contents} = File.read(filename)

    data =
      file_contents
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    expanded_rows = collect_expansions(data)

    # Transpose to find expansion columns
    expanded_cols =
      Enum.zip_with(data, &Function.identity/1)
      |> collect_expansions()

    {data, expanded_rows, expanded_cols}
  end

  defp collect_expansions(rows) do
    Enum.with_index(rows)
    |> Enum.reduce([], fn {line, i}, acc ->
      if Enum.all?(line, &(&1 == ".")) do
        [i | acc]
      else
        acc
      end
    end)
  end
end

filename = "#{File.cwd!()}/files/day_11_input.txt"
result = Day11.solve(filename, 2)
IO.puts("Part 1: #{result}")

result = Day11.solve(filename, 1_000_000)
IO.puts("Part 2: #{result}")
