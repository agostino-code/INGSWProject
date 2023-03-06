const express = require('express');
const middleware = require('../middleware/middleware');

const router = express.Router();

const { getRestaurants, deleteRestaurant, adminSignIn, adminSignUp } = require("../controllers/admin");

const {
    isRequestValidated,
    validateAdminSignUpRequest,
    validateAdminSignInRequest,
} = require("../validators/admin");

router.route("/signin").post(validateAdminSignInRequest, isRequestValidated, adminSignIn);

router.route("/signup").post(validateAdminSignUpRequest, isRequestValidated, adminSignUp);

router.get('/getrestaurants', middleware.checkToken, getRestaurants);

router.delete('/deleterestaurant', middleware.checkToken, deleteRestaurant);

router.route("/").get((req, res) => {
    res.status(200).json({ msg: "Admin route" });
});

module.exports = router;

