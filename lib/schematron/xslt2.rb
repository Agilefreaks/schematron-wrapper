module Schematron
  module XSLT2
    ISO_IMPL_DIR = File.join(File.dirname(__FILE__), '../..', 'iso-schematron-xslt2')
    EXE_PATH = File.join(File.dirname(__FILE__), '../..', 'bin/saxon9he.jar')

    def self.compile(schematron)
      temp_schematron = process_includes(schematron)
      temp_schematron = expand_abstract_patterns(temp_schematron)

      create_stylesheet(temp_schematron)
    end

    private

    def self.process_includes(schematron)
      temp_file = Tempfile.new(%w(dsdl_include .sch))
      begin
        temp_file.write(schematron)
        temp_file.rewind

        output = run_saxon_transform('iso_dsdl_include.xsl', temp_file.path)
      ensure
        temp_file.close
        temp_file.unlink
      end

      output
    end

    def self.expand_abstract_patterns(schematron)
      temp_file = Tempfile.new(%w(abstract_expand .sch))
      begin
        temp_file.write(schematron)
        temp_file.rewind

        output = run_saxon_transform('iso_abstract_expand.xsl', temp_file.path)
      ensure
        temp_file.close
        temp_file.unlink
      end

      output
    end

    def self.create_stylesheet(schematron)
      temp_file = Tempfile.new(%w(svrl_for_xslt2 .xsl))
      begin
        temp_file.write(schematron)
        temp_file.rewind

        output = run_saxon_transform('iso_svrl_for_xslt2.xsl', temp_file.path, true)
      ensure
        temp_file.close
        temp_file.unlink
      end

      output
    end

    def self.run_saxon_transform(stylesheet, schema, allow_foreign = false)
      cmd = "java -cp #{EXE_PATH} net.sf.saxon.Transform"

      cmd << " -xsl:#{File.join(ISO_IMPL_DIR, stylesheet)}"
      cmd << " -s:#{schema}"

      if allow_foreign
        cmd << ' allow-foreign=true'
      end

      %x{#{cmd}}
    end
  end
end