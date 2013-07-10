class EmployerAgreementsController < ApplicationController
  before_filter :authenticate_user!
  layout  'admin'
  
  def index
    @employer_agreement = EmployerAgreement.search(params[:agreement_id])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @employer_agreement }
    end
  end
end
