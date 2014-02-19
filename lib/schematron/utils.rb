module Schematron
  module Utils
    def create_temp_file(content, &block)
      temp_file = Tempfile.new('temp_file')
      temp_file.write(content)
      temp_file.rewind

      begin
        block.call(temp_file)
      ensure
        temp_file.close
        temp_file.unlink
      end
    end

    def get_attribute_value(element, xpath)
      result = ''
      attributes = element.xpath(xpath)

      if attributes.size > 0
        result = attributes.first.value
      end

      result
    end
  end
end