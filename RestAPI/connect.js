const mongoose = require("mongoose");
mongoose.set("strictQuery", false);
const connectDB = (url) => {
  mongoose.connection.on("connected", () => {
    console.log("Mongoose connected to db");
  });
  mongoose.connection.on("disconnected", () => {
    console.log("Mongoose disconnected");
  });
  mongoose.connection.on("error", (err) => {
    console.log("Mongoose connection error", err);
  });
  return mongoose.connect(url);
};

module.exports = connectDB;