from flask import Flask
import flask
from flask_socketio import SocketIO, emit, join_room, leave_room
import eventlet

app = Flask(__name__)
socketio = SocketIO(app)
recip_sockets = {}

@app.route('/')
def index():
    return flask.render_template('chat.html')


@app.errorhandler(404)
def not_found(code):
    return flask.redirect(flask.url_for('index'))

@socketio.on("join")
def join(data):
    print("joined")
    print(data)
    join_room(data['room'])


@socketio.on('newMessage')
def newMessage(data):
    print(data['room'])
    emit('newMessage', data['message'], broadcast=True, room=data['room'])

if __name__ == '__main__':
    app.run()
