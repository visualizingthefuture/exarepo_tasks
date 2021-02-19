# frozen_string_literal: true

require 'csv'

#
module WaxTasks
  Derivative = Struct.new(:path, :label, :img)
  FileDerivative = Struct.new(:path, :label, :preview_data, :size)
  #
  class Asset
    attr_reader :id, :path

    def initialize(path, pid, variants)
      @path     = path
      @pid      = pid
      @id       = asset_id
      @variants = variants
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

    def simple_file_derivatives
      @variants.map do |label, nrow|

        # TODO: isolate file parsing in function
        # (to handle at least CSV and JSON, handle parsing errors)
        
        data = CSV.read(@path, { encoding: "bom|utf-8", headers: true, converters: :all})
        hashed_data = data.map { |d| d.to_hash }
        my_output = hashed_data

        total_rows = my_output.length

        if nrow > total_rows
          warn Rainbow("Tried to create derivative #{nrow} rows long, but asset #{@id} for item #{@pid} only has #{total_rows} rows.").yellow
        else
          my_output = my_output[0, nrow + 1]
         end

        preview_data = my_output

        size = (File.size(@path).to_f / 2**20).round(5)
        puts "Successfully generated preview for csv file: #{size} MB, #{total_rows} rows (#{nrow} used)"

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
