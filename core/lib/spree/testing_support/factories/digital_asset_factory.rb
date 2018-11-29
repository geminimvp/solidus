# frozen_string_literal: true

FactoryBot.define do
  factory :asset, class: 'Spree::Variant' do
    price { 19.99 }
    cost_price { 17.00 }
    sku { generate(:sku) }
    is_master { 0 }
    track_inventory { true }

    factory :digital_asset, class: 'Spree::DigitalAsset' do
      folder_id { 1 }
    end
  end
end
