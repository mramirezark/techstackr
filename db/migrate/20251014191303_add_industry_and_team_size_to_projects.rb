class AddIndustryAndTeamSizeToProjects < ActiveRecord::Migration[8.0]
  def change
    add_column :projects, :industry, :string
    add_column :projects, :estimated_team_size, :integer
  end
end
