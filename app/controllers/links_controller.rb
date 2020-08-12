class LinksController < ApplicationController
  before_action :set_link, only: [:show, :edit, :update, :destroy]
  before_action :get_link, only: [:redirect]
  before_action :check_duration, only: [:redirect]

  # GET /links
  # GET /links.json
  def index
    @links = Link.all
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  def redirect
    if @link
      @link.update_count request.location
      redirect_to @link.url
    end
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)
    respond_to do |format|
      if @link.save
        format.html
        format.js { }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    @link.destroy
    respond_to do |format|
      format.html { redirect_to links_url, notice: 'Link was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id]) or not_found
    end

    def get_link
      @link = Link.find_by(slug: params[:slug]) or not_found
    end

    def check_duration
      if slug_age > 30
        @link.destroy
        not_found
      end   
    end

    def slug_age
      (Date.today - @link.created_at.to_date).to_i
    end

    def not_found
      raise ActionController::RoutingError.new('Not Found')
    end

    # Only allow a list of trusted parameters through.
    def link_params
      params.require(:link).permit(:url)
    end
end
