defmodule Day4 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 4
  https://adventofcode.com/2023/day/4
  """

  @doc """
  Part 1: Reads a file, count winning numbers and calculate score
  Part 2: Reads a file, count winning numbers, calculate extra cards won.
  Return total sum of cards owned

  """
  def solve(:part_1, filename) do
    filename
    |> File.stream!()
    |> Stream.map(&calculate_score/1)
    |> Enum.sum()
  end

  def solve(:part_2, filename) do
    filename
    |> File.stream!()
    |> Stream.map(&winning_card_count/1)
    |> Enum.to_list()
    |> total_winning_cards()
  end

  def calculate_score(line) do
    winners(line)
    |> Enum.with_index()
    |> Enum.reduce(0, fn {_, i}, acc ->
      if i > 0, do: acc * 2, else: 1
    end)
  end

  def winning_card_count(line) do
    winners(line)
    |> length()
  end

  def total_winning_cards(card_totals) do
    totals =
      card_totals
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {_, i}, acc -> Map.put(acc, i, 1) end)

    card_totals
    |> Enum.with_index()
    |> Enum.reduce(totals, fn {win_count, card_num}, acc ->
      calculate_wins(card_totals, card_num + 1, card_num + win_count, acc)
    end)
    |> Enum.reduce(0, fn {_, card_num}, acc -> acc + card_num end)
  end

  defp calculate_wins(_, from, to, totals) when from > to, do: totals

  defp calculate_wins(original_totals, from, to, totals) do
    Range.new(from, to)
    |> Enum.reduce(totals, fn card_num, acc ->
      new_totals = increment_total(card_num, acc)
      win_count = Enum.at(original_totals, card_num)
      calculate_wins(original_totals, card_num + 1, card_num + win_count, new_totals)
    end)
  end

  defp increment_total(card_index, totals) do
    Map.replace!(totals, card_index, totals[card_index] + 1)
  end

  defp winners(line) do
    [winning_numbers, card_numbers] = parse_card(line)

    card_numbers
    |> Enum.filter(fn n -> Enum.member?(winning_numbers, n) end)
  end

  defp parse_card(line) do
    String.split(line, ~r/Card \d:/)
    |> List.last()
    |> String.split("|")
    |> Enum.map(&break_numbers/1)
  end

  defp break_numbers(string) do
    string
    |> String.trim()
    |> String.split(~r/\s+/)
  end
end

file_name = "#{File.cwd!()}/files/day_4_input.txt"
result = Day4.solve(:part_1, file_name)
IO.puts("Part 1: #{result}")

result = Day4.solve(:part_2, file_name)
IO.puts("Part 2: #{result}")
