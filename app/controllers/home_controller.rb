class HomeController < ApplicationController
  def index
    @cats = Category.find(:all)

  end

  def map
    @cats = Category.find(:all)
    render(:locals => {:data => "/markers.xml"}) 
  end

  def markers
    respond_to do |format|
      @markers = Event.find(:all)
      format.xml { render :xml => @markers.to_xml( :only => [:attending, :event_id, :title, :lat, :lon, :description]) }
      format.json { render :json => @markers.to_json( :only => [:attending, :event_id, :title, :lat, :lon, :description]) }
    end
  end

  def clean
    @events = Event.find(:all)
    for event in @events
      event.destroy
    end

    redirect_to "/home/map/"
  end

  def add
  	require 'open-uri'
    require 'json'

    app_id = '1381006338788358'
    secret_id = '6aa740712042ad5e527395ac7a515ea0'
    access_token_url = "https://graph.facebook.com/oauth/access_token?client_id=#{app_id}&client_secret=#{secret_id}&grant_type=client_credentials"
    access_token_parts = (open(access_token_url).read).split("=")
    access_token = access_token_parts[1]

    event_id = params[:event_id][0]

    members_url = URI.escape("https://graph.facebook.com/#{event_id}/attending?access_token=#{access_token}")
    members_result = JSON.parse(open(members_url).read)

    event_data_url = URI.escape("https://graph.facebook.com/#{event_id}?access_token=#{access_token}")
    event_data_result = JSON.parse(open(event_data_url).read)

  	@event = Event.new
    @event.event_id = event_id
  	@event.title = event_data_result['name']
  	@event.owner = event_data_result['owner']['name']
  	@event.description = event_data_result['description']
  	@event.lat = event_data_result['venue']['latitude']
  	@event.lon = event_data_result['venue']['longitude']
  	@event.attending = members_result['data'].count
  	@event.save
  	redirect_to "/home/map/"
  end
end
