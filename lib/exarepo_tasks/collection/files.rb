# frozen_string_literal: true

#require 'mini_magick'
require 'progress_bar'
#require 'wax_iiif'
require 'csv'
#
module ExarepoTasks
  #
  class Collection
    #
    module Files
      #
      #
      def items_from_filedata
        raise Error::MissingSource, "Cannot find file data source '#{@filedata_source}'" unless Dir.exist? @filedata_source

        #pre_process_pdfs
        records = records_from_metadata
        Dir.glob(Utils.safe_join(@filedata_source, '*')).map do |path|
          item = WaxTasks::Item.new(path, @file_variants)
          #next if item.type == '.pdf'
          next puts Rainbow("Skipping #{path} because type #{item.type} is not an accepted format").yellow unless item.valid?("data")

          item.record      = records.find { |r| r.pid == item.pid }
          #item.iiif_config = @config.dig 'images', 'iiif'
          warn Rainbow("\nCould not find record in #{@metadata_source} for file item #{path}.\n").orange if item.record.nil?
          item
        end.compact
      end

      #
      #
      def pre_process_pdfs # from images; could copy to process XLSX to CSV?
        Dir.glob(Utils.safe_join(@imagedata_source, '*.pdf')).each do |path|
          target_dir = path.gsub '.pdf', ''
          next unless Dir.glob("#{target_dir}/*").empty?

          puts Rainbow("\nPreprocessing #{path} into image files. This may take a minute.\n").cyan

          opts = { output_dir: File.dirname(target_dir) }
          WaxIiif::Utilities::PdfSplitter.split(path, opts)
        end
      end

      #
      #
      def write_simple_file_derivatives
        puts Rainbow("Generating simple data derivatives for collection '#{@name}'\nThis might take awhile.").cyan

        bar = ProgressBar.new(items_from_filedata.length)
        bar.write
        items_from_filedata.map do |item|
          item.simple_file_derivatives.each do |d| # these are valid assets
            # skip if empty preview
            next if d.preview_data == []

            path = "#{@simple_file_derivative_source}/#{d.path}"
            FileUtils.mkdir_p File.dirname(path)
            next if File.exist? path

            # TODO: fix missing header, string quotations, extra line in csv fileout
            File.open(path, "wb") do |f|
              f.write(d.preview_data.to_json)

              #d.csv_preview.each do |row|
               # puts "running? running?"
                # puts row.to_json
                # csv << row
              # end
            end

            # d.csv_preview.write path
            # expected behavior: write a truncated dataset to a new directory called files derivatives

            item.record.set d.label, path if item.record? # take name of variant and write asset path to record metadata
          end
          bar.increment!
          bar.write
          item
        end.flat_map(&:record).compact
      end

    end
  end
end
