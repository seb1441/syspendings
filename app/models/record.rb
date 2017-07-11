class Record < ApplicationRecord
  validates :description, presence: true
  validates :price, presence: true,
                numericality: true
                
  scope :created_on, lambda {|date| {:conditions => ['created_at >= ? AND created_at <= ?', date.beginning_of_day, date.end_of_day]}}

  def self.today
    self.created_on(Date.today)
  end
end
