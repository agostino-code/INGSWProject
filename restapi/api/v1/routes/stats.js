const express = require('express');
const router = express.Router();
const middleware = require('../middleware/middleware');

const { getTotalforWaiter,getNumberOfOrders,getNumberOfOrdersByWaiter } = require("../controllers/stats");

router.route("/totalforwaiter").post(middleware.checkToken, getTotalforWaiter);

router.route("/numberoforders").post(middleware.checkToken, getNumberOfOrders);

router.route("/numberofordersbywaiter").post(middleware.checkToken, getNumberOfOrdersByWaiter);


router.route("/").get((req, res) => {
    res.status(200).json({ msg: "Stats route" });
}
);

module.exports = router;
