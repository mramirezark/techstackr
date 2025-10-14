class Technology < ApplicationRecord
  belongs_to :recommendation

  validates :name, presence: true
  validates :category, presence: true
end
