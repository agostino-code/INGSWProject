const { StatusCodes } = require("http-status-codes");
const MenuCategory = require("../models/category.model");

const newMenuCategory = async (req, res) => {
    try {
        if (req.decoded.role !== 'admin' && req.decoded.role !== 'supervisor') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const finded = await MenuCategory.findOne({ name: req.body.name, restaurant: req.body.restaurant });
        if (finded) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Categoria già esistente.' });
        }
        const category = new MenuCategory(req.body);
        await category.save();
        res.status(StatusCodes.CREATED).json({ msg: 'È stata creata una nuova categoria.' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};

const getMenuCategories = async (req, res) => {
    try {
/*         if (req.decoded.role !== 'admin' && req.decoded.role !== 'supervisor') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        } */
        const categories = await MenuCategory.find({ restaurant: req.body.restaurant });
        if (!categories) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Non è stata trovato nessuna categoria!' });
        }
        res.status(StatusCodes.OK).json({ categories });

    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};

const deleteMenuCategory = async (req, res) => {
    try {
        if(req.decoded.role !== 'admin' && req.decoded.role !== 'supervisor') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const category = await MenuCategory.findById(req.params.id);
        if (!category) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Categoria non trovata!' });
        }
        await category.remove();
        res.status(StatusCodes.OK).json({ msg: 'Categoria eliminata!' });
    }catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }  
};

module.exports = {
    newMenuCategory,
    getMenuCategories,
    deleteMenuCategory
};