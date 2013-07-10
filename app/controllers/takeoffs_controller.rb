class TakeoffsController < ApplicationController
  before_filter :authenticate_user!
  layout  'admin'
  def index
    @takeoffs = Takeoff.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @takeoffs }
    end
  end

  
  def show
    @takeoff = Takeoff.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @takeoff }
    end
  end

  
  def new
    @takeoff = Takeoff.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @takeoff }
    end
  end

  # GET /candidates/1/edit
  def edit
    @takeoff = Takeoff.find(params[:id])
  end

  
  def create
    @takeoff = Takeoff.new(params[:takeoff])
    @takeoff.sale_period = 3; #will be changed later
    respond_to do |format|
      if @takeoff.save
        format.html { redirect_to @takeoff, notice: 'Takeoff was successfully created.' }
        format.json { render json: @takeoff, status: :created, location: @takeoff }
      else
        format.html { render action: "new" }
        format.json { render json: @takeoff.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    @takeoff = Takeoff.find(params[:id])
    
    respond_to do |format|
      if @takeoff.update_attributes(params[:takeoff])
        format.html { redirect_to @takeoff, notice: 'Takeoff was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @takeoff.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @takeoff = Takeoff.find(params[:id])
    @takeoff.destroy

    respond_to do |format|
      format.html { redirect_to takeoffs_url }
      format.json { head :no_content }
    end
  end

  def sort_takeoff
    data = params[:sortby]
    sortby = if(data == "Name")
        "title asc"
      elsif data == "Start Date"
        "startdate desc"
      elsif data == "End Date"
        "enddate desc"
        else data == "Active"
          "active asc"

      end
     @takeoffs = Takeoff.select("*").order("#{sortby}")
      respond_to do |format|
        format.js { render :layout => false }
        #format.html { redirect_to candidates_url } # index.html.erb
      end
      
  end
end
