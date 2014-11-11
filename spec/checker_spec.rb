require "spec_helper"

describe R509::Validity::CADB::Checker do
  before :all do
    @cadb_path = File.join(File.dirname(__FILE__), 'fixtures', 'ca.db')
  end

  it 'initializes' do
    expect { R509::Validity::CADB::Checker.new(@cadb_path) }.to_not raise_error
  end

  it 'returns valid status for valid cert' do
    checker = R509::Validity::CADB::Checker.new(@cadb_path)
    status = checker.check('/CN=CA', 1)
    expect(status.status).to eq R509::Validity::VALID
  end

  it 'returns revoked status for revoked cert' do
    checker = R509::Validity::CADB::Checker.new(@cadb_path)
    status = checker.check('/CN=CA', 10)
    expect(status.status).to eq R509::Validity::REVOKED
  end

  it 'return unknown status for cert not in the database' do
    checker = R509::Validity::CADB::Checker.new(@cadb_path)
    status = checker.check('/CN=CA', 100000)
    expect(status.status).to eq R509::Validity::UNKNOWN
  end
end