require 'rails_helper'

RSpec.describe Todo, :type => :model do
  subject { described_class.new }

  it "is valid with valid attributes" do
    subject.title = 'new todo'
    subject.completed = false
    expect(subject).to be_valid
  end

  it "is not valid without a title" do
    expect(subject).to_not be_valid
  end

  it "is not valid without completed attribute" do
    subject.title = 'new todo'
    expect(subject).to_not be_valid
  end
end
