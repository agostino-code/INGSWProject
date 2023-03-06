const { StatusCodes } = require("http-status-codes");
const Item = require("../models/item.model");

const newItem = async (req, res) => {
    try {
        if (req.decoded.role !== 'admin' && req.decoded.role !== 'supervisor') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const finded = await Item.findOne({ name: req.body.name, restaurant: req.body.restaurant });
        if (finded) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Elemento già esistente.' });
        }
        const item = new Item(req.body);
        await item.save();
        res.status(StatusCodes.CREATED).json({ msg: 'È stato creato un nuovo elemento.' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
}

const getItems = async (req, res) => {
    try {
/*         if (req.decoded.role !== 'admin' && req.decoded.role !== 'supervisor') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        } */
        const items = await Item.find({ category: req.body.category }).populate('category');
        if (!items) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Non è stato trovato nessun elemento!' });
        }
        res.status(StatusCodes.OK).json({ items });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
}

const deleteItem = async (req, res) => {
    try{
        if(req.decoded.role !== 'admin' && req.decoded.role !== 'supervisor') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const item = await Item.findById(req.params.id);
        if (!item) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Elemento non trovato!' });
        }
        await item.remove();
        res.status(StatusCodes.OK).json({ msg: 'Elemento eliminato!' });
    }catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
}

const searchItem = async (req, res) => {
    try {
        if (req.decoded.role !== 'admin' && req.decoded.role !== 'supervisor' && req.decoded.role !== 'waiter') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        //search by description or name any corresponding item
        const items = await Item.find({ $or: [{ name: { $regex: req.body.search, $options: 'i' } }, { description: { $regex: req.body.search, $options: 'i' } }] }).populate('category');
        if (!items) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Non è stato trovato nessun elemento!' });
        }
        res.status(StatusCodes.OK).json({ items });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
}


module.exports = {
    newItem,
    getItems,
    deleteItem,
    searchItem,
}
