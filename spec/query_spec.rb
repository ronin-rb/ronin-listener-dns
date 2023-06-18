require 'spec_helper'
require 'ronin/listener/dns/query'

require 'socket'

describe Ronin::Listener::DNS::Query do
  let(:type)           { :A }
  let(:label)          { 'www.example.com' }
  let(:source_addr) { Addrinfo.tcp('127.0.0.1',1337) }

  subject { described_class.new(type,label,source_addr) }

  describe "#initialize" do
    it "must set #type" do
      expect(subject.type).to eq(type)
    end

    it "must set #label" do
      expect(subject.label).to eq(label)
    end

    it "must set #source_addr" do
      expect(subject.source_addr).to eq(source_addr)
    end
  end
end
