class CreateTeamMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :team_members do |t|
      t.references :recommendation, null: false, foreign_key: true
      t.string :role
      t.integer :count
      t.text :skills
      t.text :responsibilities

      t.timestamps
    end
  end
end
