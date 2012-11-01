Spree::Product.class_eval do
  scope :find_by_sku, lambda { |sku| not_deleted.includes(:master).where('spree_variants.sku = ?', sku) }

  class << self
    def import_products(products)
      fields = products.headers
      products.each do |product|
        product_record = find_by_sku(product.field(:sku)).first
        attributes = {}
        attributes[:name] = product.field(:name) if fields.include?(:name)
        attributes[:price] = product.field(:price) if fields.include?(:price)
        attributes[:description] = product.field(:description) if fields.include?(:description)
        if product_record
          product_record.update_attributes(attributes)
        else
          attributes[:sku] = product.field(:sku)
          product_record = create(attributes)
        end
        
        if fields.include?(:category)
          category = Spree::Taxonomy.category_taxonomy.root.import_category(product)
          if category && !product_record.taxons.include?(category)
            product_record.taxons << category
          end
        end
      end
    end

    def import_images(images, image_directory)
      images.each do |image|
        product_record = find_by_sku(image.field(:sku)).first
        unless product_record
          logger.info("Import Image #{image.field(:image)}: No Product found for sku #{image.field(:sku)}")
          next
        end
        path = File.join(image_directory, image.field(:image))
        unless File.exists?(path)
          logger.info("Import Image #{image.field(:image)}: Image cant be found at #{path}")
          next
        end
        file = File.new(path)
        image_record = product_record.images.find_by_attachment_file_name(image.field(:image))
        if image_record
          image_record.attachment = file
          image_record.save
        else
          product_record.images.create(attachment: file)
        end
      end
    end

    def import_properties(properties)
      properties.each do |row|
        product = find_by_sku(row.field(:sku)).first
        unless product
          logger.info("Import Image #{row.field(:image)}: No Product found for sku #{row.field(:sku)}")
          next
        end
        product.set_property(row.field(:name), row.field(:value))
      end
    end
  end

end