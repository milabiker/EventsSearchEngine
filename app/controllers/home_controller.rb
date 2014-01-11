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
      search_category = session[:search_category]
      search_lat = session[:search_lat]
      search_lon = session[:search_lon]
      search_distance = session[:search_distance]

      @markers = Event.all
      if search_category != nil
        #markers filtering by category
        @markers = Event.where(category_id: search_category)
        #markers filtering by distance from point
        if (search_lat != nil) && (search_lon != nil) && (search_distance != nil)
          filtered_markers = []

          @markers.each do |marker|
            if is_in_region(marker.lat, marker.lon, search_lat, search_lon, search_distance)
              filtered_markers += [marker]
            end
          end
          @markers = filtered_markers
        end
      end
      
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

  def search
    category_id = params[:category]
    distance = params[:search_range].to_i

    address = params[:search_address][0]

    request_url = URI.escape("http://maps.googleapis.com/maps/api/geocode/json?address=#{address}&sensor=true")
    address_results = JSON.parse(open(request_url).read)
    if (address!="")
      puts "---------- GEOCODER ----------"
      puts request_url
      puts address_results['results'][0]['geometry']['location']['lat']

      session[:search_category] = category_id
      session[:search_lat] = address_results['results'][0]['geometry']['location']['lat']
      session[:search_lon] = address_results['results'][0]['geometry']['location']['lng']
      session[:search_distance] = distance
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
    category_id = params[:category1]

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
    @event.category_id = category_id
  	@event.save
  	redirect_to "/home/map/"
  end

  RAD_PER_DEG = 0.017453293  #  PI/180
  Rkm = 6371
  def is_in_region( lat1, lon1, lat2, lon2, distance )
    

    dlon = lon2 - lon1
    dlat = lat2 - lat1

    dlon_rad = dlon * RAD_PER_DEG 
    dlat_rad = dlat * RAD_PER_DEG

    lat1_rad = lat1 * RAD_PER_DEG
    lon1_rad = lon1 * RAD_PER_DEG

    lat2_rad = lat2 * RAD_PER_DEG
    lon2_rad = lon2 * RAD_PER_DEG


    a = (Math.sin(dlat_rad/2))**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * (Math.sin(dlon_rad/2))**2
    c = 2 * Math.atan2( Math.sqrt(a), Math.sqrt(1-a))

    dKm = Rkm * c
    puts "---- DISTANCE ----"
    puts dKm

    if dKm > distance
      return false
    else
      return true
    end
  end
end
