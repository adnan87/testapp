class CmspagesController < ApplicationController
before_filter :authenticate_user!
  layout  'admin'
  
  def index
    @cmspages = Cmspage.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @cmspages }
    end
  end

 
  def show
    @cmspage = Cmspage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @cmspage }
    end
  end

  
  def new
    @cmspage = Cmspage.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @cmspage }
    end
  end

  
  def edit
    @cmspage = Cmspage.find(params[:id])
  end

  
  def create
    @cmspage = Cmspage.new(params[:cmspage])

    respond_to do |format|
      if @cmspage.save
        format.html { redirect_to @cmspage, notice: 'Page was successfully created.' }
        format.json { render json: @cmspage, status: :created, location: @cmspage }
      else
        format.html { render action: "new" }
        format.json { render json: @cmspage.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    @cmspage = Cmspage.find(params[:id])
    
    respond_to do |format|
      if @cmspage.update_attributes(params[:cmspage])
        format.html { redirect_to @cmspage, notice: 'Page was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @cmspage.errors, status: :unprocessable_entity }
      end
    end
  end

 
  def destroy
    @cmspage = Cmspage.find(params[:id])
    @cmspage.destroy

    respond_to do |format|
      format.html { redirect_to cmspages_url }
      format.json { head :no_content }
    end
  end
end
