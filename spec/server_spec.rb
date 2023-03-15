require 'spec_helper'
require 'ronin/exfil/dns/server'

describe Ronin::Exfil::DNS::Server do
  let(:domain)   { 'example.com' }
  let(:host)     { '127.0.0.1' }
  let(:port)     { 5553 }
  let(:callback) { ->(query_type,query_value) { } }

  subject { described_class.new(domain,&callback) }

  describe "#initialize" do
    it "must set #domain" do
      expect(subject.domain).to eq(domain)
    end

    it "must default #host to '0.0.0.0'" do
      expect(subject.host).to eq('0.0.0.0')
    end

    it "must default #port to 53" do
      expect(subject.host).to eq('0.0.0.0')
    end

    it "must set #callback" do
      expect(subject.callback).to be(callback)
    end

    context "when given the host: keyword argument" do
      subject { described_class.new(domain, host: host, &callback) }

      it "must set #host" do
        expect(subject.host).to eq(host)
      end
    end

    context "when given the port: keyword argument" do
      subject { described_class.new(domain, port: port, &callback) }

      it "must set #port" do
        expect(subject.port).to eq(port)
      end
    end

    context "when no block is given" do
      it do
        expect {
          described_class.new(domain)
        }.to raise_error(ArgumentError,"#{described_class}#initialize requires a callback block")
      end
    end
  end

  describe "#process" do
    let(:name)           { "s3cr3t.#{domain}" }
    let(:resource_class) { Resolv::DNS::Resource::IN::A }
    let(:transaction)    { double('Async::DNS::Transaction') }

    context "when the query value is under #domain" do
      let(:query_type) { :A }

      it "must call the #callback with the query type and query value, and then return an NXDOMAIN error" do
        expect(transaction).to receive(:fail!).with(:NXDomain)

        expect { |b|
          server = described_class.new(domain,&b)
          server.process(name,resource_class,transaction)
        }.to yield_with_args(query_type,name)
      end
    end

    context "when the query value is not under #domain" do
      let(:name) { "does.not.match.com" }

      it "must not call the #callback, and just return an NXDOMAIN error" do
        expect(transaction).to receive(:fail!).with(:NXDomain)

        expect { |b|
          server = described_class.new(domain,&b)
          server.process(name,resource_class,transaction)
        }.to_not yield_control
      end
    end
  end
end
