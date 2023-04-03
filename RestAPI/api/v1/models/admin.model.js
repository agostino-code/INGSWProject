const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const adminSchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    trim: true,
  },
  surname: {
    type: String,
    required: true,
    trim: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
    lowercase: true,
    trim: true,
  },
  hash_password: {
    type: String,
    required: true,
  },
  role:{
    type: String,
    default: "admin",
    required: false,
  },
  firstlogin: {
    type: Boolean,
    required: true,
  },
});

adminSchema.method({
  async authenticate(password) {
    return bcrypt.compare(password, this.hash_password);
  },
});

module.exports = mongoose.model("Admin", adminSchema);
