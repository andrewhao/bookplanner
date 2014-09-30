# Responsible for routing the addition and deletion of songs to a set list.
class SetListSongsController < ApplicationController
  respond_to :json

  def index
    @set_list = find_set_list
    @songs = @set_list.songs
    respond_with @songs
  end

  # Recall that this creates an association, so we merely POST with the ID
  # in the body.
  def create
    @song = find_song
    @set_list = find_set_list
    @set_list.songs << @song
    @set_list.save
    @songs = @set_list.songs
    head :created
  end

  def destroy
    @song = find_song
    @set_list = find_set_list
    @set_list.songs.delete @song
    @set_list.save
    head :ok
  end

  private

  def find_set_list
    SetList.find params[:set_list_id]
  end

  def find_song
    Song.find params[:id]
  end
end
