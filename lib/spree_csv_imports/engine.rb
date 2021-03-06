module SpreeCsvImports
  class Engine < Rails::Engine
    require 'spree/core'
    isolate_namespace Spree
    engine_name 'spree_csv_imports'

    config.autoload_paths += %W(#{config.root}/lib)

    # use rspec for tests
    config.generators do |g|
      g.test_framework :rspec
    end

    def self.activate
      if ActiveRecord::Base.connection.table_exists?('spree_products') && ActiveRecord::Base.connection.table_exists?('spree_taxonomies')
        Dir.glob(File.join(File.dirname(__FILE__), '../../app/**/*_decorator*.rb')) do |c|
          Rails.configuration.cache_classes ? require(c) : load(c)
        end
      end
    end

    config.to_prepare &method(:activate).to_proc
  end
end
