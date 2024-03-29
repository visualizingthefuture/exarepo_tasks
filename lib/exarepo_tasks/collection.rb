# frozen_string_literal: true

require 'wax_tasks'
require_relative 'collection/images'
#require_relative 'collection/metadata'
require_relative 'collection/files'

module ExarepoTasks
  #
  class Collection < WaxTasks::Collection
    attr_reader :name, :config, :ext, :search_fields,
                :page_source, :metadata_source, :imagedata_source,
                :iiif_derivative_source, :simple_derivative_source,
                :simple_file_derivative_source, :filedata_source

    include WaxTasks::Collection::Metadata
    include ExarepoTasks::Collection::Images
    include ExarepoTasks::Collection::Files

    IMAGE_DERIVATIVE_DIRECTORY = 'img/derivatives'
    FILE_DERIVATIVE_DIRECTORY = 'files/derivatives'
    DEFAULT_VARIANTS = { 'thumbnail' => 250, 'fullwidth' => 1140 }.freeze
    DEFAULT_FILE_VARIANTS = { 'data_preview' => 10 }.freeze
    # specifies number of rows in preview dataset

    #
    #
    def initialize(name, config, source, collections_dir, ext)
      @name                          = name
      @config                        = config
      @page_extension                = ext
      @site_source                   = source
      @page_source                   = WaxTasks::Utils.safe_join source, collections_dir, "_#{@name}"
      @metadata_source               = WaxTasks::Utils.safe_join source, '_data', config.dig('metadata', 'source')
      @imagedata_source              = WaxTasks::Utils.safe_join source, '_data', config.dig('images', 'source')
      @filedata_source               = WaxTasks::Utils.safe_join source, '_data', config.dig('files', 'source')
      @iiif_derivative_source        = WaxTasks::Utils.safe_join source, IMAGE_DERIVATIVE_DIRECTORY, 'iiif'
      @simple_derivative_source      = WaxTasks::Utils.safe_join source, IMAGE_DERIVATIVE_DIRECTORY, 'simple'
      @simple_file_derivative_source = WaxTasks::Utils.safe_join source, FILE_DERIVATIVE_DIRECTORY
      @search_fields                 = %w[pid label thumbnail permalink collection]
      @image_variants                = image_variants
      @file_variants                 = file_variants
    end

    #
    #
    def file_variants
      vars = @config.dig('files', 'variants') || {}
      DEFAULT_FILE_VARIANTS.merge vars
    end

    #
    #
    def clobber_derivatives
      [@iiif_derivative_source, @simple_derivative_source, @simple_file_derivative_source].each do |dir|
        if Dir.exist? dir
          puts Rainbow("Removing derivatives from #{dir}").cyan
          FileUtils.remove_dir dir, true
        end
      end
    end

  end
end
