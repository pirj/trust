require 'spec_helper'

describe "Person Model" do
  let(:person) { Person.new }
  it 'can be created' do
    person.should_not be_nil
  end
end
