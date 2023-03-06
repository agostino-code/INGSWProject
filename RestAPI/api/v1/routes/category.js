const express = require('express');
const middleware = require('../middleware/middleware');

const router = express.Router();

const { getMenuCategories,newMenuCategory,deleteMenuCategory } = require("../controllers/category");

const { validateCategoryRequest, isRequestValidated } = require("../validators/category");

router.route("/new").post(validateCategoryRequest, isRequestValidated, middleware.checkToken,newMenuCategory);

router.route("/getall").post(middleware.checkToken, getMenuCategories);

router.delete('/delete', middleware.checkToken, deleteMenuCategory);

router.route("/").get((req, res) => {
    res.status(200).json({ msg: "Category route" });
});

module.exports = router;

