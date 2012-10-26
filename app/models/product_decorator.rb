Spree::Product.class_eval do
  scope :find_by_sku, lambda { |sku| includes(:master).where('spree_variants.sku = ?', sku) }

  class << self
    def import_products(products)
      products.each do |product|
        product_record = find_by_sku(product.field(:sku)).first
        if product_record
          product_record.update_attributes(name: product.field(:name),
                                           price: product.field(:price),
                                           description: product.field(:description))
        else
          product_record = create(sku: product.field(:sku),
                                  name: product.field(:name),
                                  price: product.field(:price),
                                  description: product.field(:description))
        end
        
        category = Spree::Taxonomy.category_taxonomy.root.import_category(product)
        if category && !product_record.taxons.include?(category)
          product_record.taxons << category
        end
      end
    end
  end
end