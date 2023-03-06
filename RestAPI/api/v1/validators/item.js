const { check, validationResult } = require("express-validator");
const { StatusCodes } = require("http-status-codes");

const validateItemRequest = [
    check("name").notEmpty().withMessage("È richiesto un Nome!"),
    check("price").notEmpty().withMessage("È richiesto un Prezzo!"),
    check("price").isNumeric().withMessage("Prezzo non valido!"),
    check("category").notEmpty().withMessage("È richiesta una Categoria!"),
    check("category").isMongoId().withMessage("Categoria non valida!"),
    check("restaurant").notEmpty().withMessage("È richiesto un Ristorante!"),
    check("restaurant").isMongoId().withMessage("Ristorante non valido!"),
];

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
    validateItemRequest,
    isRequestValidated
};
