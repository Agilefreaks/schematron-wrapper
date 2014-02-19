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
end
