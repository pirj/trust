require 'spec_helper'

describe "Rating Model" do
  let(:rating) { Rating.new }
  it 'can be created' do
    rating.should_not be_nil
  end
end
