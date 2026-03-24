const express = require('express');
const middleware = require('../middleware/middleware');

const { adminChangePassword, changePassword ,getRestaurant, userSignIn, userSignUp,deleteUser } = require("../controllers/user");

const {
    isRequestValidated,
    validateChangePasswordRequest,
    validateUserSignInRequest,
    validateUserSignUpRequest,
} = require("../validators/user");

const router = express.Router();

router.route("/signin").post(validateUserSignInRequest, isRequestValidated, userSignIn);

router.route("/signup").post(validateUserSignUpRequest, isRequestValidated, userSignUp);

router.route('/getrestaurant').post(middleware.checkToken, getRestaurant);

router.route('/changepassword').post(middleware.checkToken, validateChangePasswordRequest, isRequestValidated, changePassword);

router.route('/forcechangepassword').post(middleware.checkToken, adminChangePassword);

router.route('/delete').post(middleware.checkToken, deleteUser);

router.route("/").get((req, res) => {
    res.status(200).json({ msg: "User route" });
});

module.exports = router;