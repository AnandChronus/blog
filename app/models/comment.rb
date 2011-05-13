class Comment < ActiveRecord::Base
  acts_as_nested_set
  validates_presence_of :content
  belongs_to :blog
end
