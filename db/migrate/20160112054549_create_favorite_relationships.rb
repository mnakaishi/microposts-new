class CreateFavoriteRelationships < ActiveRecord::Migration
  def change
    create_table :favorite_relationships do |t|

      t.timestamps null: false
    end
  end
end
