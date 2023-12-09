defmodule Day8Test do
  use ExUnit.Case
  doctest Day8

  test "solve/2 part 1" do
    assert Day8.solve(:part_1, "#{File.cwd!()}/test/files/day_8_test_input.txt") == 2
  end

  test "solve/2 part 1 second example" do
    assert Day8.solve(:part_1, "#{File.cwd!()}/test/files/day_8_test_2_input.txt") == 6
  end

  test "solve/2 part 2" do
    assert Day8.solve(:part_2, "#{File.cwd!()}/test/files/day_8_test_3_input.txt") == 6
  end
end
