class CreateRetweets < ActiveRecord::Migration
  def change
    create_table :retweets do |t|
      t.references :user, index: true
      t.references :micropost, index: true

      t.timestamps null: false
      t.index [:user_id,:micropost_id], unique: true
    end
  end
end