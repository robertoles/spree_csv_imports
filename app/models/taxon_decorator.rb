Spree::Taxon.class_eval do
  def import_categories(categories)
    categories.each do |category|
      import_category(category)
    end
  end

  def import_category(category)
    return if category.field(:category).blank?
    taxons = category.field(:category).split('//')
    taxons.inject(self) do |parent, name|
      if parent.children.exists?(name: name)
        parent.children.where(name: name).first
      else
        parent.children.create!(name: name, taxonomy_id: parent.taxonomy_id)
      end
    end
  end
end