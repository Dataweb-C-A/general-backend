let socket = new WebSocket("ws://localhost:3000/cable");

socket.onopen = function(e) {
  console.log("Connection established!");
}

socket.onmessage = function(event) {
  console.log(event.data);
}

socket.onclose = function(event) {
  if (event.wasClean) {
    alert('Connection closed cleanly');
  } else {
    alert('Connection died');
  }
  alert('Code: ' + event.code + ' reason: ' + event.reason);
}