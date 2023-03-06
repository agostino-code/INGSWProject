const { check, validationResult } = require("express-validator");
const { StatusCodes } = require("http-status-codes");


const validateAdminSignUpRequest = [
  check("name").notEmpty().withMessage("È richiesto un Nome!"),
  check("surname").notEmpty().withMessage("È richiesto un Cognome!"),
  check("email").notEmpty().withMessage("È richiesta una mail!"),
  check("email").isEmail().withMessage("È richiesta un email valida!"),
  /* check("password")
     .isLength({ min: 6 })
     .withMessage("Password must be at least 6 character long"), */
  check("password").isStrongPassword({
    minLength: 8,
    minLowercase: 1,
    minUppercase: 1,
    minNumbers: 1,
    minSymbols: 1,
    returnScore: false,
    pointsPerUnique: 1,
    pointsPerRepeat: 0.5,
    pointsForContainingLower: 10,
    pointsForContainingUpper: 10,
    pointsForContainingNumber: 10,
    pointsForContainingSymbol: 10,
  }).withMessage("La password non è sicura!")

];

const validateAdminSignInRequest = [
  check("email").notEmpty().withMessage("È richiesta una mail!"),
  check("email").isEmail().withMessage("È richiesta un email valida!"),
  check("password").notEmpty().withMessage("È richiesta una password!")
]

const isRequestValidated = (req, res, next) => {
  const errors = validationResult(req);

  if (errors.array().length > 0) {
    return res
      .status(StatusCodes.BAD_REQUEST)
      .json({ error: errors.array()[0].msg });
  }
  next();
};

module.exports = {
  validateAdminSignUpRequest,
  validateAdminSignInRequest,
  isRequestValidated
};