const express = require('express');
const middleware = require('../middleware/middleware');

const router = express.Router();

const { getRestaurants, deleteRestaurant, adminSignIn, adminSignUp, changePassword } = require("../controllers/admin");

const {
    isRequestValidated,
    validateAdminSignUpRequest,
    validateAdminSignInRequest,
    validateChangePasswordRequest,
} = require("../validators/admin");

router.route("/signin").post(validateAdminSignInRequest, isRequestValidated, adminSignIn);

router.route("/signup").post(validateAdminSignUpRequest, isRequestValidated, adminSignUp);

router.get('/restaurants', middleware.checkToken, getRestaurants);

router.delete('/rmrestaurant', middleware.checkToken, deleteRestaurant);

router.route('/changepassword').post(middleware.checkToken, validateChangePasswordRequest, isRequestValidated, changePassword);

router.route("/").get((req, res) => {
    res.status(200).json({ msg: "Admin route" });
});

module.exports = router;

