require 'open-uri'

class ScheduleController < ApplicationController

	def index 
		doc = Nokogiri::HTML(open("http://schedule.sxsw.com/?conference=interactive&day=13"))
		rows = doc.css("div.eventcol")
		@events = Array.new
		rows.each do |row|
			t = row.at_css("a.link_item")
			unless(t == nil)
				
				# puts t.content
				# puts t["href"]
				# puts row.at_css("div.date_time").content
				loc_node = row.at_css("div.location a")
				#.content
				#puts loc_node["href"]

				event = Event.new
				event.title = t.content
				event.link = t["href"]
				event.location = loc_node.content
				time = row.at_css("div.date_time").content.split("-")
				event.start_time = time[0].chomp
				event.end_time = time[1].chomp unless time[1] == nil
				@events << event

			end
		end
		@cols = @events.group_by(&:start_time)





	end

end
