class AddRegions < ActiveRecord::Migration[5.1]
  def up
    add_reference :users, :region, foreign_key: true, on_update: :cascade, on_delete: :nullify
    add_reference :user_privileges, :region, foreign_key: true, on_update: :cascade, on_delete: :cascade
    add_column :privileges, :regional, :boolean, default: false, null: false
  end

  def down
    drop_column :privileges, :regional
    drop_column :user_privileges, :region_id
    drop_column :users, :region_id
  end
end
