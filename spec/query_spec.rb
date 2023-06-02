require 'spec_helper'
require 'ronin/listener/dns/query'

require 'socket'

describe Ronin::Listener::DNS::Query do
  let(:type)           { :A }
  let(:label)          { 'www.example.com' }
  let(:remote_address) { Addrinfo.tcp('127.0.0.1',1337) }

  subject { described_class.new(type,label,remote_address) }

  describe "#initialize" do
    it "must set #type" do
      expect(subject.type).to eq(type)
    end

    it "must set #label" do
      expect(subject.label).to eq(label)
    end

    it "must set #remote_address" do
      expect(subject.remote_address).to eq(remote_address)
    end
  end
end
