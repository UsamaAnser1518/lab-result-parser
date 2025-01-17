class ResultsController < ApplicationController
  include ResultsParser
  
  def index
    @results = session.delete(:parsed_data)
  end

  def new
  end

  def create
    session[:parsed_data] = parse(params[:file])
    @results = parse(params[:file])   
    redirect_to results_path
  end
end