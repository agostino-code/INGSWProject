const mongoose = require("mongoose");

const RestaurantSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    owner: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Admin",
        required: true,
    },
});

module.exports = mongoose.model("Restaurant", RestaurantSchema);