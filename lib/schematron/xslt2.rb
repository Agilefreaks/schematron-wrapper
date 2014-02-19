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
      cmd = "java -cp #{EXE_PATH} net.sf.saxon.Transform"

      cmd << " -xsl:#{stylesheet}"
      cmd << " -s:#{schema}"

      if allow_foreign
        cmd << ' allow-foreign=true'
      end

      %x{#{cmd}}
    end
  end
end