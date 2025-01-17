require 'test_helper'

class ResultsParserTest < ActiveSupport::TestCase
  include ResultsParser

  test "parse should correctly process valid file data" do
    file_path = Rails.root.join('test', 'fixtures', 'files', 'lab_input.txt')
    file = File.open(file_path)
    results = parse(file)
    assert results.is_a?(Array)
    assert_not results.empty?
    file.close
  end

  test "parse should handle empty file" do
    file_path = Rails.root.join('test', 'fixtures', 'files', 'empty.txt')
    file = File.open(file_path)
    results = parse(file)
    assert results.is_a?(Array)
    assert results.empty?
    file.close
  end

  test "map_value should correctly map values for different codes" do
    assert_equal 123.45, map_value('C100', '123.45')
    assert_equal -1.0, map_value('A250', 'NEGATIVE')
    assert_equal -2.0, map_value('B250', '++')
  end
  
  test "map_format should correctly determine format based on code" do
    assert_equal 'float', map_format('C100')
  end
end
