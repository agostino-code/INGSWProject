const mongoose = require("mongoose");

const TranslatedMenuCategorySchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
    },
    index: {
        type: Number,
        required: true,
    },
    restaurant: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Restaurant",
        required: true,
    },
    category: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "MenuCategory",
        required: true,
    },
    language: {
        type: String,
        required: true,
    },
});

//virtual item model
TranslatedMenuCategorySchema.virtual("items", {
    ref: "TranslatedItem",
    localField: "_id",
    foreignField: "category",
    justOne: false,
});

module.exports = mongoose.model("TranslatedMenuCategory", TranslatedMenuCategorySchema);