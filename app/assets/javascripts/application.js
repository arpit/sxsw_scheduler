// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require_tree .


$(document).ready(function(){
	$(".star").click(function(){

		var isInMyEvents  = $(this).parents(".my_events_col")
		var parent;
		if(isInMyEvents.length == 0){
			//add to my events
			parent = $(this).parents(".all_events").find(".my_events_col")
		
		}
		else{
			//remove from my events
			var loc_string = $(this).parents(".event_cell").find(".event_loc_in_cell").html()
			parent = $(this).parents(".all_events").find('ul[data-location="'+loc_string+'"]');
	
		}
		
		var evt_node = $(this).parents("li").detach();
		evt_node.appendTo(parent);

	})
})