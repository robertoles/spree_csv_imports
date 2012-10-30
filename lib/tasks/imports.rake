require 'csv'
require 'set'

namespace :csv do
  namespace :import do
    def open_csv(file, headers)
      csv = CSV.open(file, "r", headers: true, header_converters: :symbol, return_headers: false).read
      unless headers.to_set.subset?(csv.headers.to_set)
        raise "Import failed, CSV must contain columns: #{headers}"
      end
      csv
    end

    task :console_logger => [:environment] do
      ActiveRecord::Base.logger = Logger.new(STDOUT)
    end

    task :categories, [:file] => [:environment, :console_logger] do |t, args|
      Spree::Taxonomy.import_categories(open_csv(args[:file], [:category]))
    end

    task :products, [:file] => [:environment, "csv:import:console_logger"] do |t, args|
      Spree::Product.import_products(open_csv(args[:file], [:sku]))
    end

    task :images, [:file, :image_directory] => [:environment, 'csv:import:console_logger'] do |t, args|
      Spree::Product.import_images(open_csv(args[:file], [:sku, :image]), args[:image_directory])
    end
  end
end