class StocksController < ApplicationController
  
  def search
   if params[:stock]
     @stock = Stock.find_by_ticker(params[:stock]) #method defined in stock.rb(find_by_ticker)
     @stock ||= Stock.new_from_lookup(params[:stock])
   end
   
   if @stock
     #render json: @stock
     render partial: 'lookup'
   else
     render status: :not_found, nothing: true
   end
  end
  
end