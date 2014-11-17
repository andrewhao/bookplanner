class BookBagsController < ApplicationController
  before_action :set_book_bag, only: [:show, :edit, :update, :destroy]

  # GET /book_bags
  # GET /book_bags.json
  def index
    @book_bags = BookBag.all
  end

  # GET /book_bags/1
  # GET /book_bags/1.json
  def show
  end

  # GET /book_bags/new
  def new
    @book_bag = BookBag.new
  end

  # GET /book_bags/1/edit
  def edit
  end

  # POST /book_bags
  # POST /book_bags.json
  def create
    @book_bag = BookBag.new(book_bag_params)

    respond_to do |format|
      if @book_bag.save
        format.html { redirect_to @book_bag, notice: 'Book bag was successfully created.' }
        format.json { render action: 'show', status: :created, location: @book_bag }
      else
        format.html { render action: 'new' }
        format.json { render json: @book_bag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /book_bags/1
  # PATCH/PUT /book_bags/1.json
  def update
    respond_to do |format|
      if @book_bag.update(book_bag_params)
        format.html { redirect_to @book_bag, notice: 'Book bag was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @book_bag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /book_bags/1
  # DELETE /book_bags/1.json
  def destroy
    @book_bag.destroy
    respond_to do |format|
      format.html { redirect_to book_bags_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_book_bag
      @book_bag = BookBag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def book_bag_params
      params[:book_bag].permit(:global_id)
    end
end
