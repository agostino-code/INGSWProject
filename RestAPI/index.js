const express = require("express");
require("dotenv").config();
const connectDB = require("./connect");
const app = express();
app.use(express.json());

//Port and Connect to DB
const port = process.env.PORT || 5000;
const start = async () => {
  try {
    await connectDB(process.env.MONGO_URL);
    app.listen(port, () => {
         console.log(`Server is running on port ${port}`);
    });
  } catch (error) {
      console.log("error =>", error);
  }
};

//Routes
//api/v1
app.use("/api/v1/user", require("./api/v1/routes/user"));
app.use("/api/v1/admin", require("./api/v1/routes/admin"));
app.use("/api/v1/restaurant", require("./api/v1/routes/restaurant"));
app.use("/api/v1/category", require("./api/v1/routes/category"));
app.use("/api/v1/item", require("./api/v1/routes/item"));
app.use("/api/v1/order", require("./api/v1/routes/order"));
app.use("/api/v1/middleware", require("./api/v1/routes/middleware"));

app.get("/api/v1", (req, res) => {
  res.send("Hello World!");
});

start();