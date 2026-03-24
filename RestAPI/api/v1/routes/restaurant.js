const express = require('express');
const middleware = require('../middleware/middleware');

const { newResturant, generateTranslatedCategory,generateTranslatedItem,getUserRestaurant } = require('../controllers/restaurant');

const {
  isRequestValidated,
  validateRestaurantRequest,
} = require("../validators/restaurant");

const router = express.Router();

router.route('/new').post(validateRestaurantRequest, isRequestValidated, middleware.checkToken, newResturant);
router.route('/translate/category').post(middleware.checkToken, generateTranslatedCategory);
router.route('/translate/item').post(middleware.checkToken, generateTranslatedItem);
router.route('/getusers').post(middleware.checkToken, getUserRestaurant);

router.route('/').get((req, res) => {
  res.status(200).json({ msg: 'Restaurant route' });
});

module.exports = router;