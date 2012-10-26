Spree::Taxonomy.class_eval do
  class << self
    def category_taxonomy
      Spree::Taxonomy.where(name: 'Categories', purpose: 'menu').first_or_create!
    end

    def import_categories(categories)
      category_taxonomy.root.import_categories(categories)
    end
  end
end