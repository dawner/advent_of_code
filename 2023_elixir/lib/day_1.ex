defmodule Day1 do
  @moduledoc """
  Advent of Code 30 days of challenges: Day 1
  https://adventofcode.com/2023/day/1
  """

  @doc """
  Reads a file and combines the sum of the calibration result of each line.

  """
  def calibrate_file(file_name, calibration_function) do
    file_name
    |> File.stream!()
    |> Stream.map(calibration_function)
    |> Enum.sum()
  end

  @doc """
  Combines the first digit and the last digit (in that order) to form a single two-digit number.

  ## Examples

      iex> Day1.calibrate_line_digits_only("1abc2")
      12
  """
  def calibrate_line_digits_only(line) do
    first = Regex.run(~r/\d/, line) |> List.last()
    last = Regex.scan(~r/\d/, line) |> List.last() |> List.last()

    String.to_integer("#{first}#{last}")
  end

  @doc """
  Combines the first digit and the last digit (in that order) to form a single two-digit number.
  Allows for both digits and words to be used.

  ## Examples
      iex> Day1.calibrate_line_digits_and_words("1abc2")
      12

      iex> Day1.calibrate_line_digits_and_words("two1nine")
      29

  """
  def calibrate_line_digits_and_words(line) do
    word_digits = %{
      "one" => "1",
      "two" => "2",
      "three" => "3",
      "four" => "4",
      "five" => "5",
      "six" => "6",
      "seven" => "7",
      "eight" => "8",
      "nine" => "9"
    }

    {:ok, digit_regex} = Regex.compile("(?=(\\d|#{Enum.join(Map.keys(word_digits), "|")}))")

    first = Regex.run(digit_regex, line) |> List.last()
    last = Regex.scan(digit_regex, line) |> List.flatten() |> List.last()

    first_digit = Map.get(word_digits, first, first)
    last_digit = Map.get(word_digits, last, last)

    String.to_integer("#{first_digit}#{last_digit}")
  end
end

file_name = "#{File.cwd!()}/files/day_1_input.txt"
part_one_result = Day1.calibrate_file(file_name, &Day1.calibrate_line_digits_only/1)
IO.puts("Result with only number digits: #{part_one_result}")
part_two_result = Day1.calibrate_file(file_name, &Day1.calibrate_line_digits_and_words/1)
IO.puts("Result including word digits: #{part_two_result}")
