module Spree
  class AssetVariant < Spree::Base
    self.table_name = "spree_assets_variants"

    belongs_to :assets, foreign_key: "image_id"
    belongs_to :variants, foreign_key: "variant_id"
  end
end
