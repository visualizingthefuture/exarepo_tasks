# frozen_string_literal: true
require 'wax_tasks'

module ExarepoTasks
  #
  class Config < WaxTasks::Config

    def process_collections
      if @config.key? 'collections'
        @config['collections'].map do |k, v|
          ExarepoTasks::Collection.new(k, v, source, collections_dir, ext)
        end
      else
        []
      end
    end

  end
end
