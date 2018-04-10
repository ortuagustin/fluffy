class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.integer :subscriber_id, foreign_key: { to_table: :users }
      t.integer :subscribable_id
      t.string :subscribable_type

      t.timestamps
    end
    add_index :subscriptions, [:subscriber_id, :subscribable_id, :subscribable_type], unique: true, name: 'unique_subscription_index'
  end
end
