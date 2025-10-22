class AddEstimatedTimelineToRecommendations < ActiveRecord::Migration[8.0]
  def change
    add_column :recommendations, :estimated_timeline, :string
  end
end
