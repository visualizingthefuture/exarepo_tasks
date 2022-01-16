# frozen_string_literal: true

require 'exarepo_tasks'

RSpec.describe ExarepoTasks do
  it "has a version number" do
    expect(ExarepoTasks::VERSION).not_to be nil
  end

  it "can create site" do
    expect(ExarepoTasks::Site.return_something).to eql("something")
  end

  #it "test wax" do
  #  expect(WaxTasks::Site.new).not_to be nil
  #end
end
