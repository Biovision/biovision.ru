class CreateProjects < ActiveRecord::Migration[5.1]
  def up
    unless Project.table_exists?
      create_table :projects do |t|
        t.timestamps
        t.boolean :visible, default: true, null: false
        t.boolean :highlight, default: true, null: false
        t.integer :priority, limit: 2, default: 1, null: false
        t.string :uuid, null: false
        t.string :name, null: false
        t.string :slug, null: false
        t.string :url
        t.string :image
        t.string :image_alt_text
        t.string :lead
        t.text :description
      end

      Privilege.create(slug: 'portfolio_manager', name: 'Управляющий портфолио')
    end
  end

  def down
    if Project.table_exists?
      drop_table :projects
    end
  end
end
