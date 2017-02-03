class WelcomeController < ApplicationController
  def main
    authorize! :show, params[:controller]  
  end

  def loader_token
     respond_to do |format|
      format.html
      format.txt
    end
  end
end
