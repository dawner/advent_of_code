defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "finds first and last digit in a string" do
    assert Day1.calibrate_line_digits_only("a1b2c3d4e5f") == 15
    assert Day1.calibrate_line_digits_only("pqr3stu8vwx") == 38
    assert Day1.calibrate_line_digits_only("treb7uchet") == 77
  end


  test "finds first and last digit and/or word of a digit in a strin" do
    assert Day1.calibrate_line_digits_and_words("a1b2c3d4e5f") == 15
    assert Day1.calibrate_line_digits_and_words("pqr3stu8vwx") == 38
    assert Day1.calibrate_line_digits_and_words("a1b2c3d4e5f") == 15
    assert Day1.calibrate_line_digits_and_words("eightwothree") == 83
    assert Day1.calibrate_line_digits_and_words("abcone2threexyz") == 13
    assert Day1.calibrate_line_digits_and_words("xtwone3four") == 24
    assert Day1.calibrate_line_digits_and_words("4nineeightseven2") == 42
    assert Day1.calibrate_line_digits_and_words("zoneight234") == 14
    assert Day1.calibrate_line_digits_and_words("7pqrstsixteen") == 76

    # Overlapping number example requiring lookahead
    assert Day1.calibrate_line_digits_and_words("9963onefourthree6oneightq") == 98
  end
end
