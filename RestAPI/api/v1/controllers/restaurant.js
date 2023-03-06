const { StatusCodes } = require("http-status-codes");
const Restaurant = require("../models/restaurant.model");

const newResturant = async (req, res) => {
    try {
        if (req.decoded.role !== 'admin') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const finded = await Restaurant.findOne({ name: req.body.name, owner: req.decoded._id });
        if (finded) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Ristorante già esistente.' });
        }
        const restaurant = new Restaurant({name: req.body.name, owner: req.decoded._id});
        await restaurant.save();
        res.status(StatusCodes.CREATED).json({ msg: 'È stato creato un nuovo ristorante.' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};

module.exports = {
    newResturant,
};
