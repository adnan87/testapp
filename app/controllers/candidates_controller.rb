class CandidatesController < ApplicationController
  
  before_filter :authenticate_user!
  layout  'admin'
  def index
    @candidates = Candidate.search(params[:status])
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @candidates }
    end
  end

 
  def show
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @candidate }
    end
  end

  def takeoff_candidate
    @candidate = Candidate.find(params[:id])
    @takeoff = params[:takeoff_id]
    @takeoffs = Takeoff.find(:all)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @candidate }
    end
  end

  
  def new
    @candidate = Candidate.new
    3.times do
      @candidate.portfolios.build
    end
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @candidate }
    end
  end

  
  def edit
    @candidate = Candidate.find(params[:id])
    @portfolios_count = @candidate.portfolios.count
    @no_of_portfolios = 3 - @portfolios_count;
    
    @no_of_portfolios.times do
      @candidate.portfolios.build
    end
  end

  
  def create
    @candidate = Candidate.new(params[:candidate])
    @candidate.status = "Requested"
    @candidate.featured = false
    respond_to do |format|
      if @candidate.save
        format.html { redirect_to @candidate, notice: 'Candidate was successfully created.' }
        format.json { render json: @candidate, status: :created, location: @candidate }
      else
        format.html { render action: "new" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    @candidate = Candidate.find(params[:id])

    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        format.html { redirect_to @candidate, notice: 'Candidate was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @candidate = Candidate.find(params[:id])
    @candidate.destroy

    respond_to do |format|
      format.html { redirect_to candidates_url }
      format.json { head :no_content }
    end
  end

  def featured
    @candidates = Candidate.featured_candidates

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @candidates }
    end
  end

  
  def approve_candidate
    @candidate = Candidate.find(params[:id])
    @candidate.status = "Approved"
    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        Notifier.candidate_status_change(@candidate).deliver
        format.html { redirect_to candidates_url, notice: 'Candidate was successfully Approved.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  def waitlist_candidate
    @candidate = Candidate.find(params[:id])
    @candidate.status = "Waitlisted"
    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        Notifier.candidate_status_change(@candidate).deliver
        format.html { redirect_to candidates_url, notice: 'Candidate was successfully Waitlisted.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  def feature_candidate
    
    @candidate = Candidate.find(params[:id])
    @candidate.status = "Approved"
    @candidate.featured = true
    @candidate.featured_date = Time.now
    @candidate.takeoff_id = params[:takeoff]
    respond_to do |format|
      if @candidate.update_attributes(params[:candidate])
        Notifier.candidate_featured(@candidate).deliver
        format.html { redirect_to featured_candidates_url , notice: 'Candidate was successfully Featured.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @candidate.errors, status: :unprocessable_entity }
      end
    end
  end

  def sort_candidate
    data = params[:sortby]
    sortby = if(data == "Email")
        "candidates.email asc"
      elsif data == "Name"
        "candidates.name asc"
      elsif data == "Phone"
        "candidates.phone desc"
      else data == "Created_at"
        "candidates.created_at desc"
      end
      @candidates = Candidate.select("*").order("#{sortby}")
      respond_to do |format|
        format.js { render :layout => false }
        #format.html { redirect_to candidates_url } # index.html.erb
      end
      
  end


end
