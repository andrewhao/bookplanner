class SongsController < ApplicationController
  respond_to :json

  def show
    @song = find_song
    respond_with @song
  end
  
  def create
    @song = Song.create song_params
    respond_with @song
  end

  def index
    @songs = Song.all
    respond_with @songs
  end

  def destroy
    @song = find_song
    @song.destroy!
    head :ok
  end

  def update
    @song = find_song
    @song.update! song_params
    respond_with @song
  end

  private

  def find_song
    Song.find params[:id]
  end

  def has_set_list?
  end

  def song_params
    params.require(:song).permit(:title, :description, :key, :raw_text)
  end
end
