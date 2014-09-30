class SetListsController < ApplicationController
  respond_to :json

  def index
    @set_lists = SetList.all
    respond_with @set_lists
  end

  def show
    @set_list = find_set_list
    respond_with @set_list
  end

  def create
    @set_list = SetList.create set_list_params
    respond_with @set_list
  end

  def update
    @set_list = find_set_list
    @set_list.update set_list_params
    respond_with @set_list
  end

  def destroy
    @set_list = find_set_list
    @set_list.destroy
    head :ok
  end

  private

  def find_set_list
    SetList.find params[:id]
  end

  def set_list_params
    params.require(:set_list).permit(:title)
  end
end
