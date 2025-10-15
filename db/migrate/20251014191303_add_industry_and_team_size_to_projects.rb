class AddIndustryAndTeamSizeToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :industry, :string
    add_column :projects, :estimated_team_size, :integer
  end
end
