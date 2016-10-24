class AddTargetBlankToPromoSlide < ActiveRecord::Migration
  def change
    add_column :promo_slides, :target_blank, :boolean
  end
end
