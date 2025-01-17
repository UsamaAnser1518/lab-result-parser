module ResultsParser
  def parse(file)
    results = []
    current_obx = nil
    File.foreach(file.path) do |line|
      if line.start_with?('OBX')
        _, _, code, value = line.strip.split('|')
        current_obx = { code: code, value: map_value(code, value), format: map_format(code), comments: [] }
        results << current_obx
      elsif line.start_with?('NTE') && current_obx
        _, _, comment = line.strip.split('|')
        current_obx[:comments] << comment
      end
    end
    results
  end

  def map_value(code, value)
    case code
    when 'C100', 'C200'
      value.to_f
    when 'A250'
      value == 'NEGATIVE' ? -1.0 : -2.0
    when 'B250'
      case value
      when 'NIL' then -1.0
      when '+' then -2.0
      when '++' then -2.0
      when '+++' then -3.0
      end
    end
  end

  def map_format(code)
    case code
    when 'C100', 'C200'
      'float'
    when 'A250'
      'boolean'
    when 'B250'
      'nil_3plus'
    end
  end
end
  