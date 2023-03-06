const { check, validationResult } = require("express-validator");
const { StatusCodes } = require("http-status-codes");

const validateRestaurantRequest = [
    check("name").notEmpty().withMessage("È richiesto un Nome!"),
];

const isRequestValidated = (req, res, next) => {
    const errors = validationResult(req);
    if (errors.array().length > 0) {
        return res.status(StatusCodes.BAD_REQUEST).json({ error: errors.array()[0].msg });
    }
    next();
}

module.exports = {
    validateRestaurantRequest,
    isRequestValidated,
};