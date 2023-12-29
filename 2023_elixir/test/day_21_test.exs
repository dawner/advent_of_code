defmodule Day21Test do
  use ExUnit.Case
  doctest Day21

  @filename "#{File.cwd!()}/test/files/day_21_test_input.txt"

  test "solve/2 part 1" do
    assert Day21.solve(@filename, 6) == 16
  end

  test "solve/2 part 2 - 10 steps" do
    assert Day21.solve(@filename, 10) == 50
  end

  test "solve/2 part 2 - 50 steps" do
    assert Day21.solve(@filename, 50) == 1594
  end

  test "solve/2 part 2 - 200 steps" do
    assert Day21.solve(@filename, 100) == 6536
  end

  test "solve/2 part 2 - 500 steps" do
    assert Day21.solve(@filename, 500) == 167_004
  end

  # Slow but finishes
  test "solve/2 part 2 - 1000 steps" do
    assert Day21.solve(@filename, 1000) == 668_697
  end

  # Too slow, times out
  # test "solve/2 part 2 - 5000 steps" do
  #   assert Day21.solve(@filename, 5000) == 16_733_044
  # end
end
