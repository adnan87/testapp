class EmployersController < ApplicationController
  
  before_filter :authenticate_user!
  layout  'admin'
  def index
    @employers = Employer.search(params[:status])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employers }
    end
  end

 
  def show
    @employer = Employer.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @employer }
    end
  end

 
  def new
    @employer = Employer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @employer }
    end
  end

  
  def edit
    @employer = Employer.find(params[:id])
  end

  
  def create
    @employer = Employer.new(params[:employer])
    @employerdomain = Employerdomain.verifydomain(@employer.email)
    if @employerdomain
      @employer.source = @employerdomain.status
      if @employer.source == "BlackListed"
        @employer.status = 'Requested'
      else
        @employer.status = 'Approved'
      end
      
    else
      @employer.status = 'Requested'
      @employer.source = "Others"
    end
    respond_to do |format|
      if @employer.save
        format.html { redirect_to @employer, notice: 'Employer was successfully created.' }
        format.json { render json: @employer, status: :created, location: @employer }
      else
        format.html { render action: "new" }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    @employer = Employer.find(params[:id])

    respond_to do |format|
      if @employer.update_attributes(params[:employer])
        format.html { redirect_to @employer, notice: 'Employer was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /candidates/1
  # DELETE /candidates/1.json
  def destroy
    @employer = Employer.find(params[:id])
    @employer.destroy

    respond_to do |format|
      format.html { redirect_to employers_url }
      format.json { head :no_content }
    end
  end

 
  def approve_employer
    @employer = Employer.find(params[:id])
    @employer.status = "Approved"
    respond_to do |format|
      if @employer.update_attributes(params[:employer])
        Notifier.employer_status_change(@employer).deliver
        format.html { redirect_to employers_url, notice: 'Employer was successfully Approved.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def waitlist_employer
    @employer = Employer.find(params[:id])
    @employer.status = "WaitListed"
    respond_to do |format|
      if @employer.update_attributes(params[:employer])
        Notifier.employer_status_change(@employer).deliver
        format.html { redirect_to employers_url, notice: 'Employer was successfully Waitlisted.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @employer.errors, status: :unprocessable_entity }
      end
    end
  end

  def sort_employer
    data = params[:sortby]
    sortby = if(data == "Email")
        "employers.email asc"
      elsif data == "Name"
        "employers.name asc"
      elsif data == "Phone"
        "employers.phone asc"
      elsif data == "Source"
         "employers.source asc"   
      else data == "Created_at"
        "employers.created_at desc"
      end
      @employers = Employer.select("*").order("#{sortby}")
      respond_to do |format|
        format.js { render :layout => false }
        #format.html { redirect_to candidates_url } # index.html.erb
      end
      
  end

end
