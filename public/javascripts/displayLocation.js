let longitude = document.querySelector('#lng').innerHTML;
let latitude = document.querySelector('#lat').innerHTML;

// Initialize and add the map
function initMap() {
    // The location of fishingSpot
    const fishingSpot = { lat: Number(latitude), lng: Number(longitude) };
    // The map, centered at fishingSpot
    const map = new google.maps.Map(document.getElementById("map"), {
      zoom: 4,
      center: fishingSpot,
    });
    // The marker, positioned at fishingSpot
    const marker = new google.maps.Marker({
      position: fishingSpot,
      map: map,
    });
  }