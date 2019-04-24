require 'nokogiri'

module Schematron
  module XSLT2
    extend Schematron::Utils

    ISO_IMPL_DIR = File.join(File.dirname(__FILE__), '../..', 'iso-schematron-xslt2')
    DSDL_INCLUDES_PATH = File.join(ISO_IMPL_DIR, 'iso_dsdl_include.xsl')
    ABSTRACT_EXPAND_PATH = File.join(ISO_IMPL_DIR, 'iso_abstract_expand.xsl')
    SVRL_FOR_XSLT2_PATH = File.join(ISO_IMPL_DIR, 'iso_svrl_for_xslt2.xsl')
    EXE_PATH = File.join(File.dirname(__FILE__), '../..', 'bin/saxon9he.jar')

    def self.compile(schematron)
      temp_schematron = process_includes(schematron)
      temp_schematron = expand_abstract_patterns(temp_schematron)

      create_stylesheet(temp_schematron)
    end

    def self.validate(stylesheet, xml)
      create_temp_file(stylesheet) do |temp_stylesheet|
        create_temp_file(xml) do |temp_xml|
          execute_transform(temp_stylesheet.path, temp_xml.path)
        end
      end
    end

    def self.get_errors(validation_result)
      result = []

      document = Nokogiri::XML(validation_result) do |config|
        config.options = Nokogiri::XML::ParseOptions::NOBLANKS | Nokogiri::XML::ParseOptions::NOENT
      end

      document.xpath('//svrl:failed-assert').each do |element|
        result.push({message: element.xpath('./svrl:text').text.strip,
                     role: get_attribute_value(element, '@role'),
                     location: get_attribute_value(element, '@location')})
      end

      result
    end

    private

    def self.process_includes(content_to_transform)
      create_temp_file(content_to_transform) { |temp_file| execute_transform(DSDL_INCLUDES_PATH, temp_file.path) }
    end

    def self.expand_abstract_patterns(content_to_transform)
      create_temp_file(content_to_transform) { |temp_file| execute_transform(ABSTRACT_EXPAND_PATH, temp_file.path) }
    end

    def self.create_stylesheet(content_to_transform)
      create_temp_file(content_to_transform) { |temp_file| execute_transform(SVRL_FOR_XSLT2_PATH, temp_file.path, true) }
    end

    def self.execute_transform(stylesheet, schema, allow_foreign = false)
      cmd = "java "

      # https://stackoverflow.com/questions/1491325/how-to-speed-up-java-vm-jvm-startup-time
      cmd << " -XX:TieredStopAtLevel=1"
      cmd << " -XX:CICompilerCount=1"
      cmd << " -XX:+UseSerialGC"
      cmd << " -XX:-UsePerfData"
      cmd << " -Xshare:auto"
      cmd << " -Xmx512m"

      cmd << " -cp #{EXE_PATH} net.sf.saxon.Transform"

      cmd << " -xsl:#{stylesheet}"
      cmd << " -s:#{schema}"


      if allow_foreign
        cmd << ' allow-foreign=true'
      end

      # cmd << " -client -dev"

      %x{#{cmd}}
    end
  end
end