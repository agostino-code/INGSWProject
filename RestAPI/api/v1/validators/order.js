const { check, validationResult } = require("express-validator");
const { StatusCodes } = require("http-status-codes");

const validateOrderRequest = [
    check("items").notEmpty().withMessage("È richiesto un elemento!"),
    check("items").isArray().withMessage("Elemento non valido!"),
    check("items.*.item").notEmpty().withMessage("È richiesto un elemento!"),
    check("items.*.item").isMongoId().withMessage("Elemento non valido!"),
    check("items.*.quantity").notEmpty().withMessage("È richiesta una quantità!"),
    check("items.*.quantity").isNumeric().withMessage("Quantità non valida!"),
    check("items.*.quantity").isInt({ min: 1 }).withMessage("Quantità non valida!"),
    check("restaurant").notEmpty().withMessage("È richiesto un ristorante!"),
    check("restaurant").isMongoId().withMessage("Ristorante non valido!"),
    check("table").notEmpty().withMessage("È richiesto un tavolo!"),
    check("table").isNumeric().withMessage("Tavolo non valido!"),
    check("table").isInt({ min: 1 }).withMessage("Tavolo non valido!"),
    check("waiter").notEmpty().withMessage("È richiesto un cameriere!"),
    check("waiter").isMongoId().withMessage("Cameriere non valido!"),
    check("status").notEmpty().withMessage("È richiesto uno stato!"),
    check("status").isIn(["pending", "completed", "deleted"]).withMessage("Stato non valido!"),
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
    validateOrderRequest,
    isRequestValidated
}