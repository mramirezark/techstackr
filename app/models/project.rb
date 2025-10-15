class Project < ApplicationRecord
  belongs_to :user
  has_one :recommendation, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, maximum: 100 }
  validates :description, presence: true, length: { minimum: 10, maximum: 1000 }
  validates :project_type, presence: true
  validates :industry, presence: true
  validates :estimated_team_size, presence: true, numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 1000 }

  enum :status, { pending: "pending", processing: "processing", completed: "completed", failed: "failed" }, default: :pending

  # Common industry options
  INDUSTRIES = [
    "Technology",
    "Healthcare",
    "Finance",
    "E-commerce",
    "Education",
    "Entertainment",
    "Travel & Hospitality",
    "Real Estate",
    "Manufacturing",
    "Retail",
    "Transportation",
    "Other"
  ].freeze
end
