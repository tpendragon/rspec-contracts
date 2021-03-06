describe "rspec with rspec-contracts support" do
  before do
    spec_data <<-END
      class Widget; end
      class Server
        def foo; end
      end
      SpecializedServer = Class.new(Server)
    END
  end

  it "counts each contract_double as a separate contract" do
    spec_data <<-END
      describe Widget do
        it { expect(contract_double :server).to receive :foo }
        it { expect(contract_double :server).to receive :baz }
      end
    END
    expect(spec_result).to have(2).contracts
  end

  it "counts duplicate contract_double definitions only once" do
    spec_data <<-END
      describe Widget do
        it { expect(contract_double :server).to receive :foo }
        it { expect(contract_double :server).to receive :foo }
      end
    END
    expect(spec_result).to have(1).contract
  end

  it "verifies contracts when the corresponding methods are called" do
    spec_data <<-END
      describe Widget do
        it { expect(contract_double :server).to receive :foo }
        it { expect(contract_double :server).to receive :baz }
      end
      describe Server do
        fulfill_contract :server
        it { Server.new.foo }
      end
    END
    expect(spec_result).to have(1).verified_contract
  end

  it "requires all implementors of an interface to support all method calls" do
    spec_data <<-END
      describe Widget do
        it { expect(contract_double :server).to receive :foo }
      end
      describe Server do
        fulfill_contract :server
        it { Server.new.foo }
      end
      describe SpecializedServer do
        fulfill_contract :server
      end
    END
    expect(spec_result).to have(0).verified_contracts
  end
end
