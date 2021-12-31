# frozen_string_literal: true

#
module ExarepoTasks
  #
  class Site
    attr_reader :config

    # TODO: using the "simple" keyword now; change to datatype, like "csv"?
    def generate_file_derivatives(name, type)
      collection = @config.find_collection name
      raise WaxTasks::Error::InvalidCollection if collection.nil?
      raise WaxTasks::Error::InvalidConfig unless %w[simple].include? type

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
