
mapHeight = $(document).height();
console.log("body  = " + mapHeight);
$(function(){
console.log("mapHeight = " + (mapHeight - $('nav.top-bar').height()));
});
$('#map').css('height', mapHeight - $('div.top-bar').height());
handler = Gmaps.build('Google');
handler.buildMap({ provider: {zoom: 19},internal: {id: 'map'}}, function(){
  markers = handler.addMarkers([
    {
      "lat": 51.589336,
      "lng": 19.133865,
      "picture": {
        "url": "https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png",
        "width":  36,
        "height": 36
      },
      "infowindow": "hello!"
    },
    {
      "lat": 51.534336,
      "lng": 19.134865,
      "picture": {
        "url": "https://addons.cdn.mozilla.net/img/uploads/addon_icons/13/13028-64.png",
        "width":  36,
        "height": 36
      },
      "infowindow": "hello!"
    }
  ]);
  handler.bounds.extendWith(markers);
  handler.fitMapToBounds();
});