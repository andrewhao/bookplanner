class BookBag < ActiveRecord::Base
  belongs_to :classroom

  #validates :classroom, presence: true
end
