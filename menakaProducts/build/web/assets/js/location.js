
var marked = false;
var distancelimit;
var latitude;
var longitude;

function initAutocomplete() {
    var map = new google.maps.Map(document.getElementById('map'), {
        center: {lat: 6.926132, lng: 79.877951},
        zoom: 13,
        mapTypeId: 'roadmap'
    });


    // custom code
    var longLat = {lat: -34, lng: 151};
    var marker = new google.maps.Marker({
        position: longLat,
        map: map,
        title: 'lol'
    });

    marker.setMap(map);
    // map.setCenter(new google.maps.LatLng(-34,151));
    // Create the search box and link it to the UI element.
    var input = document.getElementById('pac-input');
    var searchBox = new google.maps.places.SearchBox(input);
    map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);


    // Bias the SearchBox results towards current map's viewport.
    map.addListener('bounds_changed', function () {
        searchBox.setBounds(map.getBounds());
    });

    var markers = [];
    // Listen for the event fired when the user selects a prediction and retrieve
    // more details for that place.
    searchBox.addListener('places_changed', function () {
        var places = searchBox.getPlaces();

        if (places.length === 0) {
            return;
        }

        // Clear out the old markers.
        markers.forEach(function (marker) {
            marker.setMap(null);
        });
        markers = [];

        // For each place, get the icon, name and location.
        var bounds = new google.maps.LatLngBounds();

        places.forEach(function (place) {
            if (!place.geometry) {
                console.log("Returned place contains no geometry");
                return;
            }
            var latlong = place.geometry.location.toString().replace("(", "").replace(")", "");
            var lat = latlong.split(",")[0] * 1;
            var long = latlong.split(",")[1] * 1;
            
            
            latitude = lat;
            longitude = long;
            
            marked = true;
            
            var icon = {
                url: 'assets/img/location.png',
                size: new google.maps.Size(71, 71),
                origin: new google.maps.Point(0, 0),
                anchor: new google.maps.Point(17, 34),
                scaledSize: new google.maps.Size(50, 50)
            };

            // Create a marker for each place.
            markers.push(new google.maps.Marker({
                map: map,
                icon: icon,
                title: place.name,
                position: place.geometry.location

            }));

            if (place.geometry.viewport) {
                // Only geocodes have viewport.
                bounds.union(place.geometry.viewport);
            } else {
                bounds.extend(place.geometry.location);
            }
        });
        map.fitBounds(bounds);

    });
}

//function getDistance(lat, long) {
//    var counter;
//    var origin = {lat: 6.896926, lng: 79.860329}; // delivery point location
//    var destination = {lat: lat, lng: long}; // client's location
//    //var destination = 'Dematagoda, Colombo, Sri Lanka'; // client's location
//
//    var service = new google.maps.DistanceMatrixService;
//    service.getDistanceMatrix({
//        origins: [origin],
//        destinations: [destination],
//        travelMode: 'DRIVING',
//        unitSystem: google.maps.UnitSystem.METRIC,
//        avoidHighways: false,
//        avoidTolls: false
//    }, function (response, status) {
//        if (status !== 'OK') {
//            alert('Error was: ' + status);
//        } else {
//
//            var results = response.rows[0].elements;
//
//            var distance = results[0].distance.text; // gives the distance
//            var duration = results[0].duration.text; // gives the duration
//
//
//            console.log(duration);
//            counter = distance;
//            distancelimit = distance;
//            latitude = lat;
//            longitude = long;
//            console.log(distancelimit);
//            marked = true;
//        }
//    });
//    
//}




function saveLocation() {
    var address = document.getElementById("address").value;
    var street = document.getElementById("street").value;
    var zip = document.getElementById("zip").value;
    var contact = document.getElementById("contact").value;

    var request = new XMLHttpRequest();
    request.onreadystatechange = function () {
        if (request.readyState === 4 && request.status === 200) {
            if (request.responseText === "LOGIN_0") {
                window.location = "login.jsp";
            } else if (request.responseText === "LOCATION@saved") {
                showAlert("location@saved");
            } else {
                showAlert(request.responseText);
            }
        }
    };
    request.open("GET", "location?address=" + address + "&street=" + street + "&contact=" + contact + "&zip=" + zip + "&distance=" + distancelimit + "&marked=" + marked + "&latitude=" + latitude + "&longitude=" + longitude, true);
    request.send();
}

function userAgent() {
    if (/Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent)) {
        if (window.navigator.geolocation) {

            location.onclick = function () {
                window.navigator.geolocation.getCurrentPosition(showLocation, showError);
            };

            location.className = "btn btn-sm btn-primary";
            location.innerHTML = "get my location";
            location.style.cssText = "width: 300px; margin-top: 20px;";

            document.getElementById("loc").appendChild(location);
        } else {
            console.log('device doese not support geolocation');
        }

        function showLocation(location) {
            var long = location.coords.longitude;
            var lat = location.coords.latitude;
            latitude = lat;
            longitude = long;
            marked = true;
            console.log(long);
            console.log(lat);

        }

        function showError(error) {
            var er;
            switch (error.code) {
                case error.PERMISSION_DENIED:
                    er = "permission for location service is not allowed. please allow it first.";
                    break;
                case error.POSITION_UNAVAILABLE:
                    er = "we can't find your location at this moment.";
                    break;
                case error.TIMEOUT:
                    er = "please try again later";
                    break;
                case error.UNKNOWN_ERROR:
                    er = "An unknown error occurred.";
                    break;
            }

            alert(er);
        }
    }
}
