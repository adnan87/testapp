class AgreementsController < ApplicationController
  before_filter :authenticate_user!
  layout  'admin'
  
  def index
    @agreements = Agreement.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @agreements }
    end
  end

  
  def show
    @agreement = Agreement.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @agreement }
    end
  end

  
  def new
    @agreement = Agreement.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @agreement }
    end
  end

 
  def edit
    @agreement = Agreement.find(params[:id])
  end

 
  def create
    @agreement = Agreement.new(params[:agreement])

    respond_to do |format|
      if @agreement.save
        format.html { redirect_to @agreement, notice: 'Agreement was successfully created.' }
        format.json { render json: @agreement, status: :created, location: @agreement }
      else
        format.html { render action: "new" }
        format.json { render json: @agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def update
    @agreement = Agreement.find(params[:id])
    
    respond_to do |format|
      if @agreement.update_attributes(params[:agreement])
        format.html { redirect_to @agreement, notice: 'Agreement was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @agreement.errors, status: :unprocessable_entity }
      end
    end
  end

  
  def destroy
    @agreement = Agreement.find(params[:id])
    @agreement.destroy

    respond_to do |format|
      format.html { redirect_to agreements_url }
      format.json { head :no_content }
    end
  end

  def sort_agreement
    data = params[:sortby]
    sortby = if(data == "Title")
        "title asc"
      elsif data == "Version"
        "status asc"
      elsif data == "IsActive"
        "isactive asc"
          
      end
     @agreements = Agreement.select("*").order("#{sortby}")
      respond_to do |format|
        format.js { render :layout => false }
        #format.html { redirect_to candidates_url } # index.html.erb
      end
      
  end
end
