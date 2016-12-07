class Todo < ActiveRecord::Base
  attr_accessible :completed, :title
  validates :title, presence: true
  validates_inclusion_of :completed, :in => [true, false]
end
