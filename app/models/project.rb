class Project < ApplicationRecord
  has_one :recommendation, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :project_type, presence: true

  enum :status, { pending: "pending", processing: "processing", completed: "completed", failed: "failed" }, default: :pending
end
