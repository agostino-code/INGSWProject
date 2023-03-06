const express = require('express');
const middleware = require('../middleware/middleware');

const router = express.Router();

const { getOrders,deleteOrder,updateOrder,newOrder } = require("../controllers/order");

const { validateOrderRequest, isRequestValidated } = require("../validators/order");

router.route("/new").post(validateOrderRequest, isRequestValidated, middleware.checkToken, newOrder);

router.route("/get").get(middleware.checkToken, getOrders);

router.route("/delete").post(middleware.checkToken, deleteOrder);

router.route("/update").post(middleware.checkToken, updateOrder);

router.route("/").get((req, res) => {
    res.status(200).json({ msg: "Order route" });
});

module.exports = router;



