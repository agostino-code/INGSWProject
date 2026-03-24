const mongoose = require("mongoose");

const MenuCategorySchema = new mongoose.Schema({
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
});

//virtual item model
MenuCategorySchema.virtual("items", {
    ref: "Item",
    localField: "_id",
    foreignField: "category",
    justOne: false,
    sort: {
        index: 1,
    },
    
    
});

module.exports = mongoose.model("MenuCategory", MenuCategorySchema);