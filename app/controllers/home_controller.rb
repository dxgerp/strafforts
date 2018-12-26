class HomeController < ApplicationController
  def index
    return if cookies.signed[:access_token].nil?

    athlete = Athlete.find_by(access_token: cookies.signed[:access_token])
    if athlete.nil?
      # Something's not right. Destroy access_token cookie and try connect again.
      cookies.delete(:access_token)
      redirect_to root_path
    else
      redirect_to "/athletes/#{athlete.id}"
    end
  end
end
