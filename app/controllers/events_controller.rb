class EventsController < ApplicationController

	def show
		@events = Event.find(:all)
	end

end
