const express = require('express');
const middleware = require('../middleware/middleware');

const router = express.Router();

const { getItems, newItem, deleteItem, searchItem, updateIndexItem } = require("../controllers/item");

const { validateItemRequest, isRequestValidated } = require("../validators/item");

router.route("/new").post(validateItemRequest, isRequestValidated, middleware.checkToken, newItem);

router.route("/get").post(middleware.checkToken, getItems);

router.delete('/delete', middleware.checkToken, deleteItem);

router.route("/search").post(middleware.checkToken, searchItem);

router.route("/changeindex").post(middleware.checkToken, updateIndexItem);

router.route("/").get((req, res) => {
    res.status(200).json({ msg: "Item route" });
});

module.exports = router;
