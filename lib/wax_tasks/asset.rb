# frozen_string_literal: true

require 'csv'
require 'json'

#
module WaxTasks
  Derivative = Struct.new(:path, :label, :img)
  FileDerivative = Struct.new(:path, :label, :preview_data, :size)
  #
  class Asset
    attr_reader :id, :path

    def initialize(path, pid, variants, type)
      @path     = path
      @pid      = pid
      @id       = asset_id
      @variants = variants
      @type     = type
    end

    #
    #
    def asset_id
      id = File.basename @path, '.*'
      id.prepend "#{@pid}_" unless id == @pid
      id
    end

    #
    #
    def simple_derivatives
      @variants.map do |label, width|
        img = MiniMagick::Image.open @path
        if width > img.width
          warn Rainbow("Tried to create derivative #{width}px wide, but asset #{@id} for item #{@pid} only has a width of #{img.width}px.").yellow
        else
          img.resize width
        end

        img.format 'jpg'
        Derivative.new("#{@id}/#{label}.jpg", label, img)
      end
    end

    def parse_csv
      data = CSV.read(@path, { encoding: "bom|utf-8", headers: true, converters: :all})
      data.map { |d| d.to_hash }
    end

    def parse_json
      data = File.read(@path, { encoding: "bom|utf-8"})
      parsed_data = JSON.parse(data)
    end


    def simple_file_derivatives
      @variants.map do |label, nrow|

        puts "type: "
        puts @type

        parsed_data = []
        
        # read data based on type and store in parsed_data

        case @type
        when ".csv"
          parsed_data = parse_csv()
        when ".json"
          parsed_data = parse_json()
        when ".xls" || ".xlsx"
          warn Rainbow(".xls/.xlsx support not currently implemented, skipping for now").yellow
        end

        total_rows = parsed_data.length

        if nrow > total_rows
          warn Rainbow("Tried to create derivative #{nrow} rows long, but asset #{@id} for item #{@pid} only has #{total_rows} rows.").yellow
          preview_data = parsed_data
        else
          preview_data = parsed_data[0, nrow]
         end

        size = (File.size(@path).to_f / 2**20).round(5)
        puts "Successfully generated preview for #{@type} file: #{size} MB, #{total_rows} rows (#{nrow} used)"
        puts preview_data[0]
        return [] if preview_data == []
        FileDerivative.new("#{@id}/#{label}.json", label, preview_data, size)
      end
    end

    #
    #
    def to_iiif_image_record(is_only, index, base_opts)
      opts = base_opts.clone

      opts[:is_primary]    = index.zero?
      opts[:section_label] = "Page #{index + 1}" unless is_only
      opts[:path]          = @path
      opts[:manifest_id]   = @pid
      opts[:id]            = @id
      opts[:variants]      = @variants

      WaxIiif::ImageRecord.new(opts)
    end
  end
end
