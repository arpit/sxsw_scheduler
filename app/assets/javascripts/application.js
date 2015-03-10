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


function supports_html5_storage() {
  try {
    return 'localStorage' in window && window['localStorage'] !== null;
  } catch (e) {
    return false;
  }
}

function removeFromArray(arr, removeItem){
	return jQuery.grep(arr, function(value) {
  		return value != removeItem;
	});
}


$(document).ready(function(){

	var m_e  = localStorage.getItem("my_events");
	var my_events;

	// prevent local storage till after I have manually clicked
	// all the stars that are in my saved list
	// Not efficient at all, cause it's causing dom reflows
	var allow_storage = false;
	if (m_e == null || m_e == ""){
		my_events = [];
	}
	else{
		my_events = m_e.split("|");
	}

	$(".star").click(function(){
		var isInMyEvents  = $(this).parents(".my_events_col")
		var parent;
		var clicked_li =  $(this).parents("li")
		var event_id = clicked_li.attr("data-event-id")
		if(isInMyEvents.length == 0){
			//add to my events
			if(allow_storage){
				my_events.push(event_id);
				localStorage.setItem("my_events",my_events.join("|"))
			}
			parent = $(this).parents(".all_events").find(".my_events_col")
		
		}
		else{
			//remove from my events
			if(allow_storage){
				my_events = removeFromArray(my_events, event_id);
				localStorage.setItem("my_events",my_events.join("|"))
			}
			var loc_string = $(this).parents(".event_cell").find(".event_loc_in_cell").html()
			parent = $(this).parents(".all_events").find('ul[data-location="'+loc_string+'"]');
	
		}
		
		var evt_node = clicked_li.detach();
		evt_node.appendTo(parent);

	});

	for(var i=0; i<my_events.length; i++){
		$("a."+my_events[i]+"").click();
	}

	allow_storage = true;
})