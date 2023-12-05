defmodule Day3 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 3
  https://adventofcode.com/2023/day/3
  """
  @doc """
  Part 1: Reads a file, count "parts" (digits) adajacent to symbols and sum their values
  Part 2: Reads a file, tracking "gears" ('*' symbol).
  For those with exactly 2 adjacent numbers, multiply the numbers and sum the results
  """
  def solve(:part_1, filename) do
    filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> count_line_parts()
    |> elem(0)
    |> Enum.sum()
  end

  def solve(:part_2, filename) do
    filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.with_index()
    |> collect_gear_values()
    |> Enum.sum()
  end

  def count_line_parts(lines) do
    Enum.reduce(lines, {[], nil}, fn line, {parts, prev_line} ->
      symbol_indexes = collect_indexes(line, ~r/([^\d\.\n])/)
      prev_symbol_indexes = collect_indexes(prev_line, ~r/([^\d\.\n])/)

      parts =
        extract_inline_parts(parts, line, ~r/(\d+)*[^\d\.]/)
        |> extract_inline_parts(line, ~r/[^\d\.](\d+)*/)
        |> extract_vertical_parts(prev_line, symbol_indexes)
        |> extract_vertical_parts(line, prev_symbol_indexes)

      {parts, line}
    end)
  end

  def collect_gear_values(lines_with_index) do
    lines_with_index
    |> Enum.reduce({%{}, nil, nil}, fn {line, index}, acc ->
      find_gear_counts(line, index, acc)
    end)
    |> elem(0)
    |> Enum.reduce([], fn {_, {matches, count}}, acc ->
      if count == 2 do
        [Enum.at(matches, 0) * Enum.at(matches, 1) | acc]
      else
        acc
      end
    end)
  end

  def find_gear_counts(line, _, {gear_acc, mid_line, top_line})
      when top_line == nil or mid_line == nil,
      do: {gear_acc, line, mid_line}

  def find_gear_counts(line, line_count, {gear_acc, mid_line, top_line}) do
    gear_indexes = collect_indexes(mid_line, ~r/(\*)+/)

    gear_acc =
      extract_inline_gear_values(gear_acc, {mid_line, line_count - 1}, ~r/(\d+)+\*/)
      |> extract_inline_gear_values({mid_line, line_count - 1}, ~r/\*(\d+)+/)
      |> extract_vertical_gear_values(line, line_count - 1, gear_indexes)
      |> extract_vertical_gear_values(top_line, line_count - 1, gear_indexes)

    {gear_acc, line, mid_line}
  end

  defp extract_inline_parts(parts, nil, _), do: parts

  defp extract_inline_parts(parts, line, regex) do
    Regex.scan(regex, line, return: :index)
    |> Enum.reduce([], fn regex_match, acc ->
      check_part_match(regex_match, acc, line)
    end)
    |> Enum.concat(parts)
  end

  defp extract_inline_gear_values(gear_acc, {_, line_count}, _) when line_count <= 0, do: gear_acc

  defp extract_inline_gear_values(gear_acc, {line, line_count}, regex) do
    Regex.scan(regex, line, return: :index)
    |> Enum.reduce(gear_acc, fn regex_match, acc ->
      find_gear_match_and_update(acc, regex_match, {line, line_count})
    end)
  end

  defp extract_vertical_parts(parts, nil, _), do: parts

  defp extract_vertical_parts(parts, line, symbol_indexes) do
    Regex.scan(~r/(\d+)/, line, return: :index)
    |> Enum.reduce([], fn [{start, length} = match_index, _], acc ->
      num_index = count_adjacent_index(match_index, symbol_indexes)

      if num_index > 0 do
        match_value = line |> String.slice(start, length) |> String.to_integer()
        acc ++ List.duplicate(match_value, num_index)
      else
        acc
      end
    end)
    |> Enum.concat(parts)
  end

  defp extract_vertical_gear_values(gear_acc, line, line_num, gear_indexes) do
    Regex.scan(~r/(\d+)/, line, return: :index)
    |> Enum.reduce(gear_acc, fn [{start, length} = match, _], acc ->
      match_value = String.slice(line, start, length) |> String.to_integer()

      match
      |> get_adjacent_indexes(gear_indexes)
      |> process_vertical_gear_match(match_value, line_num, acc)
    end)
  end

  defp process_vertical_gear_match(adjacent_indexes, match_value, line_num, gear_acc) do
    Enum.reduce(adjacent_indexes, gear_acc, fn gear_index, acc ->
      update_gear_counts(match_value, gear_index, line_num, acc)
    end)
  end

  defp collect_indexes(nil, _), do: []

  defp collect_indexes(line, regex) do
    regex
    |> Regex.scan(line, return: :index)
    |> Enum.map(fn [{i, _}, {_, _}] -> i end)
  end

  defp count_adjacent_index(match, symbol_indexes) do
    Enum.count(symbol_indexes, fn index -> adjacent?(index, match) end)
  end

  defp get_adjacent_indexes(match, symbol_indexes) do
    Enum.filter(symbol_indexes, fn index -> adjacent?(index, match) end)
  end

  defp adjacent?(symbol_index, {match_index, _}) when match_index > symbol_index + 1 do
    false
  end

  defp adjacent?(symbol_index, {match_index, _}) when match_index >= symbol_index - 1 do
    true
  end

  defp adjacent?(symbol_index, {match_index, match_length}) when match_index < symbol_index - 1 do
    match_index + match_length - symbol_index >= 0
  end

  defp check_part_match([_], acc, _), do: acc

  defp check_part_match([_, {start, length}], matches, line) do
    match = String.slice(line, start, length)
    [String.to_integer(match) | matches]
  end

  def find_gear_match_and_update(
        gear_counts,
        [{start, length}, {digit_start, digit_length}],
        {line, line_count}
      ) do
    match_value = String.slice(line, digit_start, digit_length) |> String.to_integer()
    gear_index = if start == digit_start, do: start + length - 1, else: start
    update_gear_counts(match_value, gear_index, line_count, gear_counts)
  end

  defp update_gear_counts(match_value, gear_index, line_count, gear_counts) do
    case gear_counts do
      %{{^gear_index, ^line_count} => {matches, count}} ->
        %{gear_counts | {gear_index, line_count} => {[match_value | matches], count + 1}}

      _ ->
        Map.put(gear_counts, {gear_index, line_count}, {[match_value], 1})
    end
  end
end

filename = "#{File.cwd!()}/files/day_3_input.txt"
result = Day3.solve(:part_1, filename)
IO.puts("Part 1: #{result}")
result = Day3.solve(:part_2, filename)
IO.puts("Part 2: #{result}")
