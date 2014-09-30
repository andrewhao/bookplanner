class SetListToSong < ActiveRecord::Base
  belongs_to :set_list
  belongs_to :song
end
