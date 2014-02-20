require 'spec_helper'

describe Schematron::XSLT2 do
  SAMPLES_DIR = File.expand_path('../../../spec/support/samples', __FILE__)

  let(:params) { {} }

  describe 'compile' do
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

  describe 'get_errors' do
    subject { Schematron::XSLT2.get_errors(params[:validation_result]) }

    context 'validation result has errors' do
      before { params[:validation_result] = File.read(File.join(SAMPLES_DIR, 'validation_result.xml')) }

      it 'returns array with 2 elements' do
        result = subject

        expect(result.size).to eq(2)
      end

      it 'contains messages' do
        result = subject

        expect(result[0][:message]).to eq('ePatient.13 - Gender is 9906001 (Female), but eHistory.18 - Pregnancy is 3118011 while it must be 3118003 (Possible, Uncomfirmed).')
        expect(result[1][:message]).to eq('eTimes.03 - Unit Notified by Dispatch Date/Time 2013-10-02T14:00:50+07:00 should be before eTimes.13 - Unit Back in Service Date/Time 2013-10-02T14:00:50+07:00.')
      end

      it 'contains location' do
        result = subject

        expect(result[0][:location]).to eq("/*:EMSDataSet[namespace-uri()='http://www.nemsis.org'][1]/*:Header[namespace-uri()='http://www.nemsis.org'][1]/*:PatientCareReport[namespace-uri()='http://www.nemsis.org'][1]")
        expect(result[1][:location]).to eq("/*:EMSDataSet[namespace-uri()='http://www.nemsis.org'][1]/*:Header[namespace-uri()='http://www.nemsis.org'][1]/*:PatientCareReport[namespace-uri()='http://www.nemsis.org'][1]/*:eTimes[namespace-uri()='http://www.nemsis.org'][1]")
      end

      it 'contains role' do
        result = subject

        expect(result[0][:role]).to eq('[FATAL]')
        expect(result[1][:role]).to eq('[FATAL]')
      end
    end
  end
end
