const { check, validationResult } = require("express-validator");
const { StatusCodes } = require("http-status-codes");
const User = require("../models/user.model");

const validateUserSignUpRequest = [
    check("name").notEmpty().withMessage("È richiesto un Nome!"),
    check("surname").notEmpty().withMessage("È richiesto un Cognome!"),
    check("email").notEmpty().withMessage("È richiesta una mail!"),
    check("email").isEmail().withMessage("È richiesta un email valida!"),
    check("email").custom(async (value) => {
        const user = await User.findOne({ email: value });
        if (user) {
            return Promise.reject("Email già in uso!");
        }
    }),
    check("password").notEmpty().withMessage("È richiesta una password!"),
    check("role").notEmpty().withMessage("È richiesto un ruolo!"),
    //check role is valid waiter,kitchen,supervisor
    check("role").isIn(['waiter', 'kitchen', 'supervisor']).withMessage("Ruolo non valido!"),
    check("restaurant").notEmpty().withMessage("È richiesto un ristorante!"),
    check("restaurant").isMongoId().withMessage("Ristorante non valido!")
];

const validateUserSignInRequest = [
    check("email").notEmpty().withMessage("È richiesta una mail!"),
    check("email").isEmail().withMessage("È richiesta un email valida!"),
    check("password").notEmpty().withMessage("È richiesta una password!")
]

const validateChangePasswordRequest = [
    check("oldPassword").notEmpty().withMessage("È richiesta la vecchia password!"),
    check("newPassword").notEmpty().withMessage("È richiesta la nuova password!"),
    check("newPassword").isStrongPassword({
        minLength: 8,
        minLowercase: 1,
        minUppercase: 1,
        minNumbers: 1,
        minSymbols: 1,
    }).withMessage("La nuova password non è sicura!"),
    check("newPassword").not().equals("oldPassword").withMessage("La nuova password non può essere uguale alla vecchia!")
]

const isRequestValidated = (req, res, next) => {
    const errors = validationResult(req);

    if (errors.array().length > 0) {
        return res
            .status(StatusCodes.BAD_REQUEST)
            .json({ error: errors.array()[0].msg });
    }
    next();
}

module.exports = {
    validateUserSignUpRequest,
    validateUserSignInRequest,
    validateChangePasswordRequest,
    isRequestValidated
};