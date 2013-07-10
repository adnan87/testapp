class EmployerdomainsController < ApplicationController
  
  before_filter :authenticate_user!
  layout  'admin'
  def index
    @employerdomain = Employerdomain.search(params[:status])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employerdomain }
    end
  end

  
  def show
    @employerdomain = Employerdomain.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employerdomain }
    end
  end

  
  def new
    @employerdomain = Employerdomain.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employerdomain }
    end
  end

 
  def edit
    @employerdomain = Employerdomain.find(params[:id])
  end

  
  def create
    @employerdomain = Employerdomain.new(params[:employerdomain])
    respond_to do |format|
      if @employerdomain.save
        format.html { redirect_to @employerdomain, notice: 'Employer Domain was successfully created.' }
        format.json { render json: @employerdomain, status: :created, location: @employerdomain }
      else
        format.html { render action: "new" }
        format.json { render json: @employerdomain.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    @employerdomain = Employerdomain.find(params[:id])

    respond_to do |format|
      if @employerdomain.update_attributes(params[:employerdomain])
        format.html { redirect_to @employerdomain, notice: 'Employer Domain was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employerdomain.errors, status: :unprocessable_entity }
      end
    end
  end

 
  def destroy
    @employerdomain = Employerdomain.find(params[:id])
    @employerdomain.destroy

    respond_to do |format|
      format.html { redirect_to employerdomains_url }
      format.json { head :no_content }
    end
  end

  def sort_domain
    data = params[:sortby]
    sortby = if(data == "Employerdomain")
        "employer_domain asc"
      else data == "Status"
        "status asc"
      end
      @employerdomain = Employerdomain.select("*").order("#{sortby}")
      respond_to do |format|
        format.js { render :layout => false }
        #format.html { redirect_to candidates_url } # index.html.erb
      end
      
  end

end
