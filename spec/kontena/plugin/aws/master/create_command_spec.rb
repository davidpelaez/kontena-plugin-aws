require 'spec_helper'
require 'aws-sdk'
require 'kontena/plugin/aws_command'

describe Kontena::Plugin::Aws::Master::CreateCommand do

  let(:subject) do
    described_class.new(File.basename($0))
  end

  let(:provisioner) do
    spy(:provisioner)
  end

  before(:each) do
    allow(Aws::EC2::Client).to receive(:new).and_return(spy)
  end

  describe '#run' do
    it 'prompts user if options are missing' do
      expect(subject).to receive(:prompt).at_least(:once).and_return(spy)
      allow(subject).to receive(:provisioner).and_return(provisioner)
      subject.run(['--name', 'foo', '--skip-auth-provider'])
    end

    it 'passes options to provisioner' do
      options = [
        '--name', 'foo',
        '--access-key', 'foo',
        '--secret-key', 'bar',
        '--region', 'eu-west-1',
        '--key-pair', 'master-key',
        '--no-prompt',
        '--skip-auth-provider'
      ]
      expect(subject).to receive(:prompt).at_least(:once).and_return(spy)
      expect(subject).to receive(:provisioner).with('foo', 'bar', 'eu-west-1').and_return(provisioner)
      expect(provisioner).to receive(:run!).with(
        hash_including(key_pair: 'master-key')
      )
      subject.run(options)
    end
  end
end
