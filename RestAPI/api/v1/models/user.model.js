const mongoose = require("mongoose");
const bcrypt = require("bcrypt");

const userSchema = new mongoose.Schema({
  name: {
      type: String,
      require: true,
      trim: true,
  },
  surname: {
      type: String,
      require: true,
      trim: true,
  },
  email: {
      type: String,
      require: true,
      trim: true,
      unique: true,
      lowercase: true,
  },
  hash_password: {
      type: String,
      require: true,
  },
  role: {
      type: String,
      enum: ['waiter', 'kitchen', 'supervisor'],
      require: true,
  },
  restaurant: {
      type: mongoose.Schema.Types.ObjectId,
    ref: "Restaurant",
    required: true,
  },
  firstlogin: {
   type: Boolean,
   required: true,
 },
},{ timestamps: true });

userSchema.method({
  async authenticate(password) {
     return bcrypt.compare(password, this.hash_password);
  },
});

module.exports = mongoose.model("User", userSchema);