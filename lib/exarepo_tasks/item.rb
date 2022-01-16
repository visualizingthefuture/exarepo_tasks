# frozen_string_literal: true
require 'wax_tasks'

module ExarepoTasks
  #
  class Item < WaxTasks::Item
    attr_accessor :record, :iiif_config
    attr_reader :pid

    #
    #
    #
    def accepted_formats
      { "image" => %w[.png .jpg .jpeg .tiff .tif],
      "data" => %w[.csv .json] }
    end

    def valid?(asset_type)
      accepted_formats[asset_type].include? @type or @type == 'dir'
    end

    def assets
      if accepted_formats["image"].include? @type
        [ExarepoTasks::Asset.new(@path, @pid, @variants, @type)]
      elsif  accepted_formats["data"].include? @type
        [ExarepoTasks::Asset.new(@path, @pid, @variants, @type)]
      elsif @type == 'dir'
        paths = Dir.glob("#{@path}/*{#{(accepted_formats["image"] + accepted_formats["data"]).join(',')}}").sort
        paths.map { |p| ExarepoTasks::Asset.new(p, @pid, @variants, @type) }
      else
        []
      end
    end

    #
    #
    def simple_file_derivatives
      @assets.map(&:simple_file_derivatives).flatten
    end

  end
end
