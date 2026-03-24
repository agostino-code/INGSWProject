const { StatusCodes } = require("http-status-codes");
const Order = require("../models/order.model");
const User = require("../models/user.model");

const newOrder = async (req, res) => {
    try {
        if (req.decoded.role !== 'waiter') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const order = new Order(req.body);
        await order.save();
        res.status(StatusCodes.CREATED).json({ msg: 'È stato creato un nuovo ordine.' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
}

const getOrders = async (req, res) => {
    try {
        if (req.decoded.role !== 'waiter' && req.decoded.role !== 'kitchen') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }

        if (req.decoded.role === 'waiter') {
            const orders = await Order.find({ waiter: req.decoded._id }).populate({ path: 'items.item', populate: { path: 'category' } });
            if (!orders) {
                return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Non è stato trovato nessun ordine!' });
            }
            res.status(StatusCodes.OK).json({ orders });
        } else {

            const user = await User.findById(req.decoded._id);
            if (!user) {
                return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Utente non trovato!' });
            }
        
            const orders = await Order.find({ restaurant: user.restaurant }).populate({ path: 'items.item', populate: { path: 'category' } });
            if (!orders) {
                return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Non è stato trovato nessun ordine!' });
            }
            res.status(StatusCodes.OK).json({ orders });
        }
    }
    catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
}

const deleteOrder = async (req, res) => {
    try {
        if (req.decoded.role !== 'waiter') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const order = await Order.findById(req.body.id);
        if (!order) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Ordine non trovato!' });
        }
        order.status = "deleted";
        await order.save();
        res.status(StatusCodes.OK).json({ msg: 'Ordine annullato!' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
}

const updateOrder = async (req, res) => {
    try {
        if (req.decoded.role !== 'waiter') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const order = await Order.findById(req.body.id);
        if (!order) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Ordine non trovato!' });
        }
        order.status = "completed";
        await order.save();
        res.status(StatusCodes.OK).json({ msg: 'Ordine completato!' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
}


module.exports = {
    newOrder,
    getOrders,
    deleteOrder,
    updateOrder,
}

