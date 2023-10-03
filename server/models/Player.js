const mongoose = require("mongoose")

const playerSchema = new mongoose.Schema({
    nickname: {
        required: true,
        type: String
    },
    socketID: {
        type: String
    },
    isPartyLeader: {
        type: Boolean,
        default: false
    },
    points: {
        type: Number,
        default: 0
    },
    level: {
        type: Number,
        default: 0 
    },
    tier: {
        type: String
    }
})

const playerModel = mongoose.model('Player', playerSchema)
module.exports = {playerModel, playerSchema}