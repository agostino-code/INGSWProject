const express = require('express');
const middleware = require('../middleware/middleware');

const { setFirstLogin, changePassword ,getRestaurant, userSignIn, userSignUp } = require("../controllers/user");

const {
    isRequestValidated,
    validateChangePasswordRequest,
    validateUserSignInRequest,
    validateUserSignUpRequest,
} = require("../validators/user");

const router = express.Router();

router.route("/signin").post(validateUserSignInRequest, isRequestValidated, userSignIn);

router.route("/signup").post(validateUserSignUpRequest, isRequestValidated, userSignUp);

router.get('/getrestaurant', middleware.checkToken, getRestaurant);

router.post('/setfirstlogin', middleware.checkToken, setFirstLogin);

router.post('/changepassword', middleware.checkToken, validateChangePasswordRequest, isRequestValidated, changePassword);

router.route("/").get((req, res) => {
    res.status(200).json({ msg: "User route" });
});

module.exports = router;