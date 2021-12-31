# frozen_string_literal: true

require 'exarepo_tasks'

RSpec.describe ExarepoTasks do
  it "has a version number" do
    expect(ExarepoTasks::VERSION).not_to be nil
  end

  it "broccoli is gross" do
    expect(Foodie::Food.portray("Broccoli")).to eql("Gross!")
  end

  it "anything else is delicious" do
    expect(Foodie::Food.portray("Not Broccoli")).to eql("Delicious!")
  end

  #it "test wax" do
  #  expect(WaxTasks::Site.new).not_to be nil
  #end
end
