const express = require("express");
const restaurantModel = require("./api/v1/models/restaurant.model");
require("dotenv").config();
const connectDB = require("./connect");
var app = express();
app.use(express.json());
cors = require("cors");

var corsOptions = {
  origin: "*",
  credentials: true,
  optionsSuccessStatus: 200, // some legacy browsers (IE11, various SmartTVs) choke on 204
};

app.use(cors(corsOptions));

app.use(function (req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header("Access-Control-Allow-Credentials", true);
  res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
  res.header("Access-Control-Allow-Headers", "Origin, Content-Type, Accept, Authorization");
  next();
});

port = process.env.PORT || 5000;

// const start = async () => {
//   try {
//     await connectDB(process.env.MONGO_URL);
//     app.listen(port, () => {
//       console.log(`Server started on port ${port}`);
//     });
//   } catch (e) {
//     console.log(e);
//   }
// };

//https server
const https = require('https');
const fs = require('fs');
const options = {
  key: fs.readFileSync('./key.pem'),
  cert: fs.readFileSync('./cert.pem')
};

const start = async () => {
  try {
    await connectDB(process.env.MONGO_URL);
    https.createServer(options, app).listen(port, () => {
      console.log(`Server started on port ${port}`);
    });
  } catch (e) {
    console.log(e);
  }
};

app.use("/api/v1/user", require("./api/v1/routes/user"));
app.use("/api/v1/admin", require("./api/v1/routes/admin"));
app.use("/api/v1/restaurant", require("./api/v1/routes/restaurant"));
app.use("/api/v1/category", require("./api/v1/routes/category"));
app.use("/api/v1/item", require("./api/v1/routes/item"));
app.use("/api/v1/order", require("./api/v1/routes/order"));
app.use("/api/v1/middleware", require("./api/v1/routes/middleware"));
app.use("/api/v1/stats", require("./api/v1/routes/stats"));

const Category = require("./api/v1/models/category.model");
const TranslatedCategory = require("./api/v1/models/translated.category.model");
const Restaurant = require("./api/v1/models/restaurant.model");



// app.get("/menu/:restaurant", async (req, res) => {

//   res.setHeader('Content-Type', 'text/html');

//   Restaurant.findById(req.params.restaurant).then(async (restaurant) => {
//     const categories = await Category.find({ restaurant: req.params.restaurant }).populate('items').sort({index:1});
//     html = compiledFunction({
//       name: restaurant.name,
//       categories: categories,
//     });
//     res.send(html);
//   });
// });

app.set('view engine', 'ejs');

app.get("/:language/menu/:restaurant/", async (req, res) => {

  // res.setHeader('Content-Type', 'text/html');
try{
  Restaurant.findById(req.params.restaurant).then(async (restaurant) => {
    const categories = await Category.find({ restaurant: req.params.restaurant }).populate('items').sort({index:1});
    categories.forEach((category)=>{
      category.items.sort((a,b)=>{
        return a.index - b.index;
      });
    });

    if(req.params.language === 'it'){
      res.render('pages/menu', {
        name: restaurant.name,
        categories: categories,
      });
    }

    if(req.params.language !== 'it'){
      const translatedcategory = await TranslatedCategory.find({ restaurant: req.params.restaurant, language: req.params.language }).populate('items').sort({index:1});
      if(translatedcategory.length === 0){
        if(await translatecategory(req.params.restaurant,req.params.language)){
        await translateitem(req.params.restaurant,req.params.language);
        }
      }
      translatedcategory.forEach((category)=>{
        category.items.sort((a,b)=>{
          return a.index - b.index;
        });
      });

      res.render('pages/menu', {
        name: restaurant.name,
        categories: translatedcategory,
      });
    }
  });
}catch(e){
  console.log(e);
}
});

app.get("/api/v1", (req, res) => {
  res.send("Hello World!");
});

start();