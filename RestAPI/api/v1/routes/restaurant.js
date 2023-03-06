const express = require('express');
const middleware = require('../middleware/middleware');

const { newResturant } = require('../controllers/restaurant');

const {
  isRequestValidated,
  validateRestaurantRequest,
} = require("../validators/restaurant");

const router = express.Router();

router.route('/new').post(validateRestaurantRequest, isRequestValidated, middleware.checkToken, newResturant);

router.route('/').get((req, res) => {
  res.status(200).json({ msg: 'Restaurant route' });
});

module.exports = router;