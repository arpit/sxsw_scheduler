require 'open-uri'

class ScheduleController < ApplicationController

	def index

		max_age = 60*60*1000 #1hour

		if(params[:day] == nil)
			day = 13
		else
			day = params[:day]
		end

		day_int = day.to_i

		last_event = Event.last(:event_day == day_int)
		now = Time.now
		if(last_event != nil)
			puts "HOW OLD >>> #{(now - last_event.created_at)} "
		end

		if(last_event != nil && ( (now - last_event.created_at) < max_age))
			puts "Loading from db"
			evts = Event.where(:event_day == day_int);
			@events = evts.to_a()
		else
			Event.delete_all
			puts "Scraping site!"
			doc = Nokogiri::HTML(open("http://schedule.sxsw.com/?conference=interactive&day=#{day}"))
			rows = doc.css("div.eventcol")
			@events = Array.new
			ActiveRecord::Base.transaction do
				rows.each do |row|
					#puts ("=>>>"+event_id)
					t = row.at_css("a.link_item")
					unless(t == nil)
						event_id =  t['id']
						loc_node = row.at_css("div.location a")
						event = Event.new
						event.event_day = day_int
						event.event_id = event_id
						event.title = t.content
						event.link = t["href"]
						event.location = loc_node.content
						time = row.at_css("div.date_time").content.split("-")
						event.start_time = time[0].chomp
						event.end_time = time[1].chomp unless time[1] == nil
						@events << event
						event.save
					end
				end
			end
		end

		@cols = @events.group_by(&:start_time)
		@created_at = @events.first.created_at
		end

end
