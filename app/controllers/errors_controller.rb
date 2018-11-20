class ErrorsController < ApplicationController
  def index; end

  def not_found
    redirect_to '/errors/404'
  end

  def internal_server_error
    redirect_to '/errors/500'
  end
end
