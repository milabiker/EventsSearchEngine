function showMap(markers_data) {
  handler = Gmaps.build('Google');
  handler.buildMap({ provider: {zoom: 7},internal: {id: 'map'}}, function(){
    markers = handler.addMarkers(markers_data);
    //handler.bounds.extendWith(markers);
    handler.fitMapToBounds();
    handler.map.centerOn( {lat: 51.75424, lng: 19.398193} )
  });
}


mapHeight = $(document).height();
console.log("body  = " + mapHeight);
$(function(){
console.log("mapHeight = " + (mapHeight ));
console.log("nav.top-bar = " + $('nav.top-bar').height());
console.log("section title" +  $('section p.title').height());
});

$('#map').css('height', mapHeight -30 - $('nav.top-bar').height() - $('section p.title').height());
console.log("map = " + $('#map').height());

$.getJSON( "/markers.json", function( data ) {
  var markers = new Array();
  var i = 0;

  var picture = {
    "url": "https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png",
    "width":  36,
    "height": 36
  };

  $.each( data, function( key, val ) {
    var temp_description = val.description
    var cloud_content = "<b>" + val.title + "</b><br>" + val.description.substring(0,50) + "...<br><a href = \"https://www.facebook.com/events/" + val.event_id + "\" target=\"_blank\"> więcej... </a>"
    markers[i] = { "infowindow" : cloud_content, "lat" : val.lat, "lng" : val.lon, "picture" : picture };
    i++;
  });

  showMap(markers);
});