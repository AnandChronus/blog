class Blog < ActiveRecord::Base
  validates_uniqueness_of :title

  has_many :comments, :dependent => :destroy

end
