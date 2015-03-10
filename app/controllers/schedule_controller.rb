require 'open-uri'

class ScheduleController < ApplicationController

	def index

		if(params[:day] == nil)
			day = 13
		else
			day = params[:day]
		end

		day_int = day.to_i

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
					puts "saving"
					#event.save
				end
			end
		end
		@cols = @events.group_by(&:start_time)
	end

end
