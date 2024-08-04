class AddSlugToWorkshops < ActiveRecord::Migration[7.1]
  def change
    add_column :workshops, :slug, :string
    add_index :workshops, :slug, unique: true
  end
end
