class Record < ApplicationRecord
  validates :description, presence: true
  validates :price, presence: true,
                numericality: true

  # scope :date, lambda {|date| {:conditions => ['created_at >= ? AND created_at <= ?', date.beginning_of_day, date.end_of_day]}}
  #
  # def self.today
  #   self.created_on(Date.today)
  # end

  def self.calculate (array, who, where)
    if array.where(id: -1).empty?
      return 0
    else
      return array.where(:who => who ).where(:split => where).sum(:price)
    end
  end
end
