/**
 * Created by Jared-IMac on 6/1/16.
 */


var socket = io('http://' + document.domain + ':' + location.port);
var name = '';
var room = '';


document.getElementById("getName").style.display = 'none';
document.getElementById("chat").style.display = 'none';

socket.on('connect', function() {
    console.log("connected");

});

socket.on("newMessage", function(data) {
    console.log("appended");
    $("<ul>").addClass("text").text(data).appendTo($(".messages"));
});

$(".input").on("submit", function(action) {
    action.preventDefault();

    var message = $("#message").val();

    if (!message)  return;
    message = room + ' - ' + name + ': ' + message
    socket.emit("newMessage", message );

    $("#message").val("");
});
$(".inputRoom").on("submit", function(action) {
    action.preventDefault();

    room = $("#room").val();
    if (!room)
        return;

    socket.emit('join', {
        room:room
    });

    $("#room").val("");
    document.getElementById("getRoom").style.display = 'none';
    document.getElementById("getName").style.display = 'initial';
});
$(".inputName").on("submit", function(action) {
    action.preventDefault();

    name = $("#name").val();

    if (!name)  return;
    $("#name").val("");

    document.getElementById("getName").style.display = 'none';
    document.getElementById("chat").style.display = 'initial';
});