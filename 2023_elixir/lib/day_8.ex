defmodule Day8 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 8
  https://adventofcode.com/2023/day/8
  """

  @doc """
    Part 1: Follow map to find number of steps required to reach a "ZZZ" node
    Part 2: Follow the map on concurrent paths to find number of steps required for
    all paths to complete in a node ending with "Z"
  """
  def solve(:part_1, filename) do
    {directions, steps} = read_file(filename)

    next_step("AAA", steps, directions, directions, "ZZZ", 0)
  end

  def solve(:part_2, filename) do
    {directions, steps} = read_file(filename)

    Map.keys(steps)
    |> Enum.filter(fn k -> String.ends_with?(k, "A") end)
    |> Enum.map(fn k ->
      next_step(k, steps, directions, directions, "Z", 0)
    end)
    # Find the lowest common step value ending in Z of all paths
    |> Enum.reduce(1, fn val, acc -> lowest_common_multiple(val, acc) end)
  end

  def lowest_common_multiple(val1, val2) do
    trunc(val1 * val2 / Integer.gcd(val1, val2))
  end

  defp next_step(step_key, steps, [], all_directions, stop_key, acc),
    do: next_step(step_key, steps, all_directions, all_directions, stop_key, acc)

  defp next_step(step_key, steps, [current_dir | directions], all_directions, stop_key, acc) do
    if stop?(step_key, stop_key) do
      acc
    else
      next_step_key(step_key, steps, current_dir)
      |> next_step(steps, directions, all_directions, stop_key, acc + 1)
    end
  end

  defp next_step_key(step_key, steps, direction) do
    Map.get(steps, step_key)
    |> get_direction(direction)
  end

  defp stop?(step_key, stop_key), do: String.ends_with?(step_key, stop_key)

  defp get_direction(step, dir)
  defp get_direction({left, _right}, "L"), do: left
  defp get_direction({_left, right}, "R"), do: right

  defp read_file(filename) do
    {:ok, contents} = File.read(filename)
    [raw_directions | raw_steps] = String.split(contents, "\n", trim: true)

    directions = String.split(raw_directions, "", trim: true)

    steps =
      raw_steps
      |> Enum.reduce(%{}, &parse_line/2)

    {directions, steps}
  end

  defp parse_line(line, acc) do
    [[_, line_key, val1, val2]] =
      Regex.scan(~r/([A-Z1-9]{3}) = \(([A-Z1-9]{3}), ([A-Z1-9]{3})\)/, line)

    Map.put(acc, line_key, {val1, val2})
  end
end

filename = "#{File.cwd!()}/files/day_8_input.txt"
result = Day8.solve(:part_1, filename)
IO.puts("Part 1: #{result}")

result = Day8.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
