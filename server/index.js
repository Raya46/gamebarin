const express = require("express")
var http = require("http")
const app = express()
const port = process.env.PORT || 3000
var server = http.createServer(app)
const mongoose = require("mongoose")
const Room = require("./models/Room")
const getWord = require("./api/getWord")
var io = require("socket.io")(server)

app.use(express.json())

const DB = 'mongodb+srv://muhammadrayaarrizki:rayarizki090106@cluster0.iys0j8y.mongodb.net/?retryWrites=true&w=majority'

mongoose.connect(DB).then(() => {
    console.log("connection successful");
}).catch((e) => {
    console.log(e)
})

io.on('connection', (socket) => {
    console.log("connected")
    socket.on("create-game", async({nickname, name, occupancy, maxRounds}) => {
        try {
            const existingRoom = await Room.findOne({name})
            if (existingRoom) {
                socket.emit("notCorrectGame", "Room with that name already exists")
                return;
            } 
            let room = new Room()
            const word = getWord()
            room.word = word
            room.name = name
            room.occupancy = occupancy
            room.maxRounds = maxRounds

            let player = {
                socketID: socket.id,
                nickname,
                isPartyLeader: true
            }
            room.players.push(player)
            room = await room.save()
            socket.join(name)
            io.to(name).emit('updateRoom', room)
        } catch (error) {
            console.log(error)
        }
    })
    socket.on('join-game', async({nickname, name}) => {
        try {
            let room = await Room.findOne({name})
            if(!room){
                socket.emit('notCorrectGame', 'Please enter a valid room name')
                return;
            }
            if(room.isJoin){
                let player = {
                    socketID: socket.id,
                    nickname
                } 
                room.players.push(player)
                socket.join(name)

                if(room.players.length === room.occupancy){
                    room.isJoin = false
                }
                room.turn = room.players[room.turnIndex]
                room = await room.save()
                io.to(name).emit('updateRoom', room)
            } else {
                socket.emit('notCorrectGame', 'The game is in progress please try later')

            }
        } catch (error) {
            console.log(error)
        }
    })

    socket.on('msg', async(data) => {
        console.log(data)
        try {
            if (data.msg === data.word) {
                let room = await Room.find({name: data.roomName})
                let userPlayer = room[0].players.filter((player) => player.nickname === data.username)
                if (data.timeTaken !== 0) {
                    userPlayer[0].points += Math.round((200/data.timeTaken)*10)
                    userPlayer[0].level += Math.round((5/data.timeTaken)*10)
                    if (userPlayer[0].level >= 0 && userPlayer[0].level <= 5) {
                        userPlayer[0].tier = 'Noob';
                      } else if (userPlayer[0].level >= 6 && userPlayer[0].level <= 10) {
                        userPlayer[0].tier = 'Intermediate';
                      } else if (userPlayer[0].level >= 11 && userPlayer[0].level <= 15) {
                        userPlayer[0].tier = 'Expert';
                      } else {
                        userPlayer[0].tier =
                            'Master'; 
                      }
                }
                room = await room[0].save()
                io.to(data.roomName).emit('msg', {
                    username: data.username,
                    msg: 'Guessed it!',
                    guessedTurn: data.guessedTurn + 1
                })
                socket.emit("close-input", "")
            } else {
                io.to(data.roomName).emit('msg', {
                    username: data.username,
                    msg: data.msg,
                    guessedTurn: data.guessedTurn,
                })
            }
        } catch (error) {
            console.log(error.toString())
        }
    })

    socket.on('change-turn', async(name) => {
        try {
            let room = await Room.findOne({name})
            let ids = room.turnIndex
            if (ids +1 === room.players.length) {
                room.currentRound+=1
            }
            if (room.currentRound <= room.maxRounds) {
                const word = getWord()
                room.word = word
                room.turnIndex = (ids+1) % room.players.length
                room.turn = room.players[room.turnIndex]
                room = await room.save()
                io.to(name).emit('change-turn', room)
            } else {
                io.to(name).emit('show-leaderboard', room.players)
            }
        } catch (error) {
            console.log(error)
        }
    })


    socket.on('update-score', async (name) => {
        try {
            const room = await Room.findOne({name})
            io.to(name).emit('update-score',room)
        } catch (error) {
            console.log(error)
        }
    })

    socket.on('reset-game', async ({name}) => {
        try {
          const room = await Room.findOne({name});
          if (!room) {
            return; // Room tidak ditemukan, tidak ada tindakan yang diambil
          }
    
          // Reset skor pemain
          room.currentRound = 1
          console.log(room.currentRound)
    
          io.to(name).emit('reset-game', room.currentRound); // Update skor ke semua pemain di room
        } catch (error) {
          console.error('Error resetting game:', error);
        }
      });

      socket.on('delete-document', async ({ collectionName, documentName }) => {
        try {
          // Hapus dokumen menggunakan Mongoose atau MongoDB Driver
          await Room.findOneAndDelete({ name: documentName });
    
          // Beri tahu klien bahwa dokumen telah dihapus
          socket.emit('document-deleted', { collectionName, documentName });
        } catch (error) {
          console.error('Gagal menghapus dokumen:', error);
        }
        console.log('berhasil menghapus dokumen')
      });

    socket.on('paint', ({details, roomName}) => {
        io.to(roomName).emit('points', {details: details})
    })

    socket.on('color-change', ({color, roomName}) => {
        io.to(roomName).emit('color-change', color)
    })

    socket.on('stroke-width', ({value, roomName}) => {
        io.to(roomName).emit('stroke-width', value)
    })

    socket.on('disconnect', async() => {
        try {
            let room = await Room.findOne({"players.socketID": socket.id});
            for(let i=0; i< room.players.length; i++) {
                if(room.players[i].socketID === socket.id) {
                    room.players.splice(i, 1);
                    break;
                }
            }
            room = await room.save();
            if(room.players.length === 1) {
                socket.broadcast.to(room.name).emit('show-leaderboard', room.players);
            } else {
                socket.broadcast.to(room.name).emit('user-disconnected', room);
            }
        } catch(err) {
            console.log(err);
        }
    })

    socket.on('clean-screen', (roomName) => {
        io.to(roomName).emit('clean-screen', '')
    })
    
})

server.listen(port, "0.0.0.0", () => {
    console.log("Server listening on port: "+port)
})