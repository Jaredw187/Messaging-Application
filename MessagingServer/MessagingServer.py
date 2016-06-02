from flask import Flask
import flask
from flask_socketio import SocketIO, emit, join_room, leave_room

app = Flask(__name__)
socketio = SocketIO(app)
recip_sockets = {}

@app.route('/')
def hello_world():
    return flask.render_template('chat.html')


@socketio.on('join')
def on_join(data):
    print("joined")
    print (data)
    join_room(data['room'])



@socketio.on('newMessage')
def newMessage(data):
    print(data)
    emit('newMessage', data, broadcast=True)


if __name__ == '__main__':
    app.run()
