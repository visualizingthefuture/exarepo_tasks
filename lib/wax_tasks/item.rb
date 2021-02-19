# frozen_string_literal: true

module WaxTasks
  #
  class Item
    attr_accessor :record, :iiif_config
    attr_reader :pid

    #
    #
    #
    def initialize(path, variants)
      @path            = path
      @variants        = variants
      @type            = type
      @pid             = File.basename @path, '.*'
      @assets          = assets
    end

    #
    #
    def accepted_formats
      { "image" => %w[.png .jpg .jpeg .tiff .tif],
      "data" => %w[.csv .json] }
    end


    #
    #
    def type
      Dir.exist?(@path) ? 'dir' : File.extname(@path).downcase
    end


    #
    #
    def valid?(asset_type)
      accepted_formats[asset_type].include? @type or @type == 'dir'
    end


    #
    #
    def record?
      @record.is_a? Record
    end

    #
    #
    def assets
      if accepted_formats["image"].include? @type
        [Asset.new(@path, @pid, @variants)]
      elsif  accepted_formats["data"].include? @type
        [Asset.new(@path, @pid, @variants)]
      elsif @type == 'dir'
        paths = Dir.glob("#{@path}/*{#{(accepted_formats["image"] + accepted_formats["data"]).join(',')}}").sort
        paths.map { |p| Asset.new(p, @pid, @variants) }
      else
        []
      end
    end

    #
    #
    def simple_derivatives
      @assets.map(&:simple_derivatives).flatten
    end

    #
    #
    def simple_file_derivatives
      @assets.map(&:simple_file_derivatives).flatten
    end

    #
    #
    def logo
      logo_uri = @iiif_config&.dig 'logo'
      "{{ '#{logo_uri}' | absolute_url }}" if logo_uri
    end

    def label
      label_key = @iiif_config&.dig 'label'
      if @record && label_key
        @record.hash.dig label_key
      else
        @pid
      end
    end

    #
    #
    def description
      description_key = @iiif_config&.dig 'description'
      @record.hash.dig description_key if description_key && @record
    end

    #
    #
    def attribution
      attribution_key = @iiif_config.dig 'attribution'
      @record.hash.dig attribution_key if attribution_key && @record
    end

    #
    #
    def iiif_image_records
      opts = base_opts.clone
      is_only = @assets.length == 1

      @assets.map.with_index do |asset, i|
        asset.to_iiif_image_record(is_only, i, opts)
      end
    end

    #
    #
    def base_opts
      opts = { label: label }
      return opts unless @iiif_config

      opts[:logo]        = logo if logo
      opts[:description] = description.to_s if description
      opts[:attribution] = attribution.to_s if attribution
      opts
    end
  end
end
