class CreateTechnologies < ActiveRecord::Migration[7.2]
  def change
    create_table :technologies do |t|
      t.references :recommendation, null: false, foreign_key: true
      t.string :name
      t.string :category
      t.text :description
      t.text :reason

      t.timestamps
    end
  end
end
