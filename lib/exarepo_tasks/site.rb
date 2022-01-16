# frozen_string_literal: true
require 'wax_tasks'
#
module ExarepoTasks
  #
  class Site < WaxTasks::Site
    attr_reader :config

    def initialize(config = nil)
     @config = ExarepoTasks::Config.new(config || WaxTasks.config_from_file)
    end


    def self.return_something
      "something"
    end

    # TODO: using the "simple" keyword now; change to datatype, like "csv"?
    def generate_file_derivatives(name, type)
      collection = @config.find_collection name
      raise ExarepoTasks::Error::InvalidCollection if collection.nil?
      raise ExarepoTasks::Error::InvalidConfig unless %w[simple].include? type

      records = case type
                when 'simple'
                  collection.write_simple_file_derivatives
                end

      if records != []
        collection.update_metadata records
        puts Rainbow("\nDone ✔").green
      end
    end
  end
end
