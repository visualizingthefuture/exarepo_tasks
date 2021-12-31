# frozen_string_literal: true

require 'mini_magick'
require 'progress_bar'
require 'wax_iiif'

#
module WaxTasks
  #
  class Collection
    #
    module Images
      #
      #
      def items_from_imagedata
        raise Error::MissingSource, "Cannot find image data source '#{@imagedata_source}'" unless Dir.exist? @imagedata_source

        pre_process_pdfs
        records = records_from_metadata
        Dir.glob(Utils.safe_join(@imagedata_source, '*')).map do |path|
          item = WaxTasks::Item.new(path, @image_variants)
          next if item.type == '.pdf'
          next puts Rainbow("Skipping #{path} because type #{item.type} is not an accepted format").yellow unless item.valid?("image")

          item.record      = records.find { |r| r.pid == item.pid }
          item.iiif_config = @config.dig 'images', 'iiif'
          warn Rainbow("\nCould not find record in #{@metadata_source} for image item #{path}.\n").orange if item.record.nil?
          item
        end.compact
      end      

    end
  end
end
