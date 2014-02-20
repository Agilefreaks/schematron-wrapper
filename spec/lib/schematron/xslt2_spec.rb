require 'spec_helper'

describe Schematron::XSLT2 do
  SAMPLES_DIR = File.expand_path('../../../../spec/support/samples', __FILE__)

  describe 'compile' do
    subject { Schematron::XSLT2.compile(input_file) }

    context 'parameter is schematron' do
      let(:input_file) { File.read(File.join(SAMPLES_DIR, 'initial.sch')) }

      it { should eq File.read(File.join(SAMPLES_DIR, 'compiled.xsl')) }
    end
  end

  describe 'validate' do
    let(:stylesheet_file) { File.read(File.join(SAMPLES_DIR, 'compiled.xsl')) }
    let(:target_xml) { File.read(File.join(SAMPLES_DIR, 'target.xml')) }

    subject { Schematron::XSLT2.validate(stylesheet_file, target_xml).gsub(/"file[^"]*/, '').gsub(/[\s]/, '') }

    it { should == File.read(File.join(SAMPLES_DIR, 'validation_result.xml')).gsub(/"file[^"]*/, '').gsub(/[\s]/, '') }
  end

  describe 'get_errors' do
    subject { Schematron::XSLT2.get_errors(validation_result) }

    context 'validation result has errors' do
      let(:validation_result) { File.read(File.join(SAMPLES_DIR, 'validation_result.xml')) }

      its(:size) { should eq 2 }

      its(:first) {
        should include(
                   message: 'ePatient.13 - Gender is 9906001 (Female), but eHistory.18 - Pregnancy is 3118011 while it must be 3118003 (Possible, Uncomfirmed).',
                   location: "/*:EMSDataSet[namespace-uri()='http://www.nemsis.org'][1]/*:Header[namespace-uri()='http://www.nemsis.org'][1]/*:PatientCareReport[namespace-uri()='http://www.nemsis.org'][1]",
                   role: '[FATAL]'
               )
      }

      its(:last) {
        should include(
                   message: 'eTimes.03 - Unit Notified by Dispatch Date/Time 2013-10-02T14:00:50+07:00 should be before eTimes.13 - Unit Back in Service Date/Time 2013-10-02T14:00:50+07:00.',
                   location: "/*:EMSDataSet[namespace-uri()='http://www.nemsis.org'][1]/*:Header[namespace-uri()='http://www.nemsis.org'][1]/*:PatientCareReport[namespace-uri()='http://www.nemsis.org'][1]/*:eTimes[namespace-uri()='http://www.nemsis.org'][1]",
                   role: '[FATAL]'
               )
      }
    end
  end
end
