require 'spec_helper'
require 'ronin/listener/dns/query'

require 'socket'

describe Ronin::Listener::DNS::Query do
  let(:type)  { :A }
  let(:label) { 'www.example.com' }

  let(:source_ip)   { '127.0.0.1' }
  let(:source_port) { 1337 }
  let(:source_addr) { Addrinfo.tcp(source_ip,source_port) }

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

  describe "#source_ip" do
    it "must return the source IP address String" do
      expect(subject.source_ip).to eq(source_ip)
    end
  end

  describe "#source_port" do
    it "must return the source port" do
      expect(subject.source_port).to eq(source_port)
    end
  end

  describe "#source" do
    it "must return the source IP:port String" do
      expect(subject.source).to eq("#{source_ip}:#{source_port}")
    end
  end

  describe "#to_s" do
    it "must return a String containing the #source_ip, #source:port, #type, and #label" do
      expect(subject.to_s).to eq("#{source_ip}:#{source_port} #{type} #{label}")
    end
  end

  describe "#to_a" do
    it "must return an Array containing the #source_ip, #source_port, #type, and #label" do
      expect(subject.to_a).to eq(
        [source_ip, source_port, type, label]
      )
    end
  end

  describe "#to_h" do
    it "must return a Hash containing the #source_ip, #source_port, #type, and #label" do
      expect(subject.to_h).to eq(
        {
          source_ip:   source_ip,
          source_port: source_port,
          type:        type,
          label:       label
        }
      )
    end
  end

  describe "#to_csv" do
    it "must convert #to_a to a CSV line" do
      expect(subject.to_csv).to eq(CSV.generate_line(subject.to_a))
    end
  end

  describe "#as_json" do
    it "must return #to_h" do
      expect(subject.as_json).to eq(subject.to_h)
    end
  end

  describe "#to_json" do
    it "must convert the #to_h form of the DNS query into JSON" do
      expect(subject.to_json).to eq(subject.to_h.to_json)
    end
  end
end
