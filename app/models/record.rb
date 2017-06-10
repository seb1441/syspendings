class Record < ApplicationRecord
  validates :description, presence: true
  validates :price, presence: true,
                numericality: true
end
