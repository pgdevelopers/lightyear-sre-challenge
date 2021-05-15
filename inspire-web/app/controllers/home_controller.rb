class HomeController < ApplicationController
  before_action :set_urls

  def index
    brooke_response = HTTParty.get(@brooke_url)
    chadiamond_response = HTTParty.get(@chadiamond_url)
    eric_response = HTTParty.get(@eric_url)
    @brooke_quote = brooke_response['quote']
    @chadiamond_quote = chadiamond_response['quote']
    @eric_quote = eric_response['quote']
  end

  private
    def set_urls
      if Rails.env.production?
        @brooke_url = 'http://brooke:8000/api/brooke'
        @chadiamond_url = 'http://chadiamond:5000/api/chadiamond'
        @eric_url = 'http://eric:3030/api/eric'
      else
        # This requires the web service to be commented out in docker-compose.yml and run
        @brooke_url = 'http://localhost/api/brooke'
        @chadiamond_url = 'http://localhost/api/chadiamond'
        @eric_url = 'http://localhost/api/eric'
      end
    end
end