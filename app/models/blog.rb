class Blog < ActiveRecord::Base
  validates_uniqueness_of :title
  validates_presence_of :title, :content

  has_many :comments, :dependent => :destroy
end
