class Recommendation < ApplicationRecord
  belongs_to :project
  has_many :technologies, dependent: :destroy
  has_many :team_members, dependent: :destroy

  validates :ai_response, presence: true
end
