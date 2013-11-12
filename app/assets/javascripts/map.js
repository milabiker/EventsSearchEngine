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
console.log("mapHeight = " + (mapHeight - $('nav.top-bar').height()));
});
$('#map').css('height', mapHeight - $('div.top-bar').height());

$.getJSON( "/markers.json", function( data ) {
  var markers = new Array();
  var i = 0;

  var picture = {
    "url": "https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png",
    "width":  36,
    "height": 36
  };

  $.each( data, function( key, val ) {
    markers[i] = { "infowindow" : val.description, "lat" : val.lat, "lng" : val.lon, "picture" : picture };
    i++;
  });

  showMap(markers);
});