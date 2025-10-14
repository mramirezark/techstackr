class TeamMember < ApplicationRecord
  belongs_to :recommendation

  validates :role, presence: true
  validates :count, presence: true, numericality: { greater_than: 0 }
end
