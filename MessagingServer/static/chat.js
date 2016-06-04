/**
 * Created by Jared-IMac on 6/1/16.
 */


var socket = io('http://' + document.domain + ':' + location.port);
var name = '';
var room = '';


document.getElementById("getName").style.display = 'none';
document.getElementById("chat").style.display = 'none';

socket.on('connect', function() {
    // bleh.
});

socket.on("newMessage", function(data) {
    var messages = document.getElementById("messages");
    data = "    " + data + '\n';
    messages.innerHTML += data;
    messages.scrollTop = messages.scrollHeight - messages.clientHeight;
});

$(".input").on("submit", function(action) {
    action.preventDefault();

    var message = $("#message").val();

    if (!message)  return;
    message = name + ': ' + message;
    socket.emit("newMessage", {message:message, room:room});

    $("#message").val("");
});
$(".inputRoom").on("submit", function(action) {
    action.preventDefault();

    room = $("#room").val();
    if (!room)
        return;

    socket.emit('join', { room:room });

    $("#room").val("");
    document.getElementById("getRoom").style.display = 'none';
    document.getElementById("getName").style.display = 'initial';
    document.getElementById("chatRoom").innerHTML = "Room Name: " + room ;

});
$(".inputName").on("submit", function(action) {
    action.preventDefault();

    name = $("#name").val();

    if (!name)  return;
    $("#name").val("");

    document.getElementById("getName").style.display = 'none';
    document.getElementById("chat").style.display = 'initial';
    document.getElementById("userName").innerHTML = "User Name: " + name;

});
$("#newName").on("click", function() { document.getElementById("getName").style.display = 'initial'});
$("#newChat").on("click", function() {
    document.getElementById("getRoom").style.display = 'initial';
    document.getElementById("chat").style.display = 'none';
    document.getElementById("chatRoom").innerHTML = "";
    socket.emit('leave', { room:room })
});
