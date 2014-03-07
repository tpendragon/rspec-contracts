describe "rspec with rspec-contracts support" do
  before do
    spec_data <<-END
      class Widget
      end
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
end