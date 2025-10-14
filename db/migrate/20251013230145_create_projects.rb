class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.text :description
      t.string :project_type
      t.string :status

      t.timestamps
    end
  end
end
