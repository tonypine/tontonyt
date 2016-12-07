class Todo < ActiveRecord::Base
  attr_accessible :completed, :title
  validates :title, presence: true
  validates :completed, presence: true
end
