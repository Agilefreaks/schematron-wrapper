require 'spec_helper'

describe Schematron::XSLT2 do
  SAMPLES_DIR = File.expand_path('../../../spec/support/samples', __FILE__)

  describe 'compile' do
    let(:params) { {} }
    subject { Schematron::XSLT2.compile(params[:schematron_file]) }

    context 'parameter is schematron' do
      before { params[:schematron_file] = File.read(File.join(SAMPLES_DIR, 'initial.sch')) }

      it 'returns compiled template' do
        expected_value = File.read(File.join(SAMPLES_DIR, 'compiled.xsl'))

        result = subject

        expect(result).to eq(expected_value)
      end
    end
  end

  describe 'validate' do
    let(:params) { {} }
    subject { Schematron::XSLT2.validate(params[:stylesheet_file], params[:target_xml]) }

    before do
      params[:stylesheet_file] = File.read(File.join(SAMPLES_DIR, 'compiled.xsl'))
      params[:target_xml] = File.read(File.join(SAMPLES_DIR, 'target.xml'))
    end

    it 'returns validation result' do
      expected_value = File.read(File.join(SAMPLES_DIR, 'validation_result.xml')).gsub(/"file[^"]*/, '').gsub(/[\s]/, '')

      result = subject.gsub(/"file[^"]*/, '').gsub(/[\s]/, '')

      expect(result).to eq(expected_value)
    end
  end
end
