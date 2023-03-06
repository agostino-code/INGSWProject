const mongoose = require("mongoose");

const OrderSchema = new mongoose.Schema({
    table: {
        type: Number,
        required: true,
    },
    waiter: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "User",
        required: true,
    },
    items: [{
        item: {
            type: mongoose.Schema.Types.ObjectId,
            ref: "Item",
            required: true,
        },
        quantity: {
            type: Number,
            required: true,
        },
    }],
    status: {
        type: String,
        required: true,
        enum: ['pending','completed','deleted'],
        default: 'pending',
    },
    restaurant: {
        type: mongoose.Schema.Types.ObjectId,
        ref: "Restaurant",
        required: true,
    },
}, { timestamps: true });


module.exports = mongoose.model("Order", OrderSchema);