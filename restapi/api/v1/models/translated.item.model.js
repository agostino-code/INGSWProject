const mongoose = require("mongoose");

const TranslatedItemSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    price: {
        type: Number,
        required: true,
    },
    allergens: {
        type: [{
            type: String
        }],
    },
    description: {
        type: String,
    },
    index: {
        type: Number,
        required: true,
    },
    category: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "TranslatedMenuCategory",
        required: true,
    },
    restaurant: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Restaurant",
        required: true,
    },
    language: {
        type: String,
        required: true,
    },
});


module.exports = mongoose.model("TranslatedItem", TranslatedItemSchema);