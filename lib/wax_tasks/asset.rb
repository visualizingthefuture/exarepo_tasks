# frozen_string_literal: true

require 'csv'

#
module WaxTasks
  Derivative = Struct.new(:path, :label, :img)
  FileDerivative = Struct.new(:path, :label, :csv_preview)
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
        # get total rows
        csv_file = File.open(@path,"r")
        #total_rows = csv_file.readlines.size
        total_rows = `wc -l < #{@path}`.to_i
        if nrow > total_rows
          warn Rainbow("Tried to create derivative #{nrow} rows long, but asset #{@id} for item #{@pid} only has #{total_rows} rows.").yellow
          csv_preview = csv_file
        else
          csv_preview = CSV.foreach(@path, headers: true).take(nrow)
        end

        FileDerivative.new("#{@id}/#{label}.csv", label, csv_preview)
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
