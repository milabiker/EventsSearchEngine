function showMap(markers_data) {
  handler = Gmaps.build('Google');
  handler.buildMap({ provider: {zoom: 7},internal: {id: 'map'}}, function(){
    markers = handler.addMarkers(markers_data);
    //handler.bounds.extendWith(markers);
    handler.fitMapToBounds();

    if(typeof LAT == "undefined")
    {
      LAT = 51.75424;
    }

    if(typeof LON == "undefined")
    {
      LON = 19.398193;
    }
    
    handler.map.centerOn( {lat: LAT, lng: LON} )
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

  $.each( data, function( key, val ) {
    var picture_url =  "/assets/marker_0.png";
    var attending = parseInt(val.attending);

    if( attending > 200 ) {
      picture_url = "/assets/marker_600.png";
    } else if ( attending > 100 ) {
      picture_url = "/assets/marker_300.png";
    }

    var picture = {
      "url": picture_url,
      "width":  28,
      "height": 40
    };

    var title_length = (val.title).length;
    if(title_length < 50) title_length = 50;
    var cloud_content = "<b>" + val.title + "</b><br>" + val.description.substring(0,title_length) + "...<br><a href = \"https://www.facebook.com/events/" + val.event_id + "\" target=\"_blank\"> więcej... </a>"
    markers[i] = { "infowindow" : cloud_content, "lat" : val.lat, "lng" : val.lon, "picture" : picture };
    i++;
  });

  showMap(markers);
});

/* ---- Date pickers ---- */
  function setCurrentDate(element){
    var today = new Date();
    var dd = today.getDate();
    var mm = today.getMonth()+1; //January is 0!

    var yyyy = today.getFullYear();
    if(dd<10){dd='0'+dd} if(mm<10){mm='0'+mm} var today = dd+'/'+mm+'/'+yyyy;
    element.value = today;
    element.val(today);
    console.log("date = " + today);
  }
  
  setCurrentDate($('#search-date'));
  var nowTemp = new Date();
  var now = new Date(nowTemp.getFullYear(), nowTemp.getMonth(), nowTemp.getDate(), 0, 0, 0, 0);
  $('#search-date').fdatepicker({
    onRender: function (date) {
            return date.valueOf() < now.valueOf() ? 'disabled' : '';
        },
    format: 'dd/mm/yyyy',
    closeButton: false});


  // $('#search-date').fdatepicker().on('show', 
  //   function(ev){
  //     console.log("Hello");
  //     $('#search-date').fdatepicker('place');
  //   });
