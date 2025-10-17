class CreateRecommendations < ActiveRecord::Migration[8.0]
  def change
    create_table :recommendations do |t|
      t.references :project, null: false, foreign_key: true
      t.text :ai_response
      t.text :summary

      t.timestamps
    end
  end
end
