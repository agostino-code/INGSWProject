const mongoose = require("mongoose");

const MenuCategorySchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    restaurant: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Restaurant",
        required: true,
    },
});


module.exports = mongoose.model("MenuCategory", MenuCategorySchema);