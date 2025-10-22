class AddRecommendedTeamSizeToRecommendations < ActiveRecord::Migration[8.0]
  def change
    add_column :recommendations, :recommended_team_size, :integer
  end
end
