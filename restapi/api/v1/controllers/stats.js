const { StatusCodes } = require("http-status-codes");
const User = require("../models/user.model");
const Order = require("../models/order.model");
const dayjs = require("dayjs");
var customParseFormat = require('dayjs/plugin/customParseFormat')
dayjs.extend(customParseFormat)

const getNumberOfOrders = async (req, res) => {
    if (req.decoded.role !== "admin") return res.status(StatusCodes.UNAUTHORIZED).json({ error: "Non sei autorizzato!" });
    const { start, end } = req.body;
    try {
        if (!start || !end) {
            return res.status(StatusCodes.BAD_REQUEST).json({
                error: "Per favore inserisci le date!",
            });
        }
        let orders = await Order.find({
            createdAt: { $gte: dayjs(start,"DD-MM-YYYY").toISOString(), $lte: dayjs(end,"DD-MM-YYYY").add(1,'day').toISOString() }, restaurant: req.body.restaurant
        });
        orders = orders.filter((order) => order.status !== "deleted");
        length = orders.length;
        return res.status(StatusCodes.OK).json({ length });
    }
    catch (error) {
        console.log(error);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};

const getNumberOfOrdersByWaiter = async (req, res) => {
    if (req.decoded.role !== "admin") return res.status(StatusCodes.UNAUTHORIZED).json({ error: "Non sei autorizzato!" });
    const { start, end } = req.body;
    try {
        if (!start || !end) {
            return res.status(StatusCodes.BAD_REQUEST).json({
                error: "Per favore inserisci le date!",
            });
        }
        const waiters = await User.find({ role: "waiter", restaurant: req.body.restaurant });
        let result = [];
        for (let i = 0; i < waiters.length; i++) {
            let orders = await Order.find({
                createdAt: { $gte: dayjs(start,"DD-MM-YYYY").toISOString(), $lte: dayjs(end,"DD-MM-YYYY").add(1,'day').toISOString() }, waiter: waiters[i]._id
            });
            orders = orders.filter((order) => order.status !== "deleted");
            length = orders.length;
            //push waiter name e surname and number of orders
            result.push({ _id: waiters[i]._id, waiter: waiters[i].name + " " + waiters[i].surname, length: length });
        }
        return res.status(StatusCodes.OK).json({ result });
    }
    catch (error) {
        console.log(error);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};

const getTotalforWaiter = async (req, res) => {
    if (req.decoded.role !== "admin") return res.status(StatusCodes.UNAUTHORIZED).json({ error: "Non sei autorizzato!" });
    const { start, end } = req.body;
    try {
        if (!start || !end) {
            return res.status(StatusCodes.BAD_REQUEST).json({
                error: "Per favore inserisci le date!",
            });
        }

        let result = [];
        let orders = await Order.find({
            createdAt: { $gte: dayjs(start,"DD-MM-YYYY").toISOString(), $lte: dayjs(end,"DD-MM-YYYY").add(1,'day').toISOString() }, restaurant: req.body.restaurant, status: { $ne: "deleted" }, waiter: req.body.waiter
        }).populate({ path: 'items.item'});;

        for (i = dayjs(start,'DD-MM-YYYY'); i <= dayjs(end,'DD-MM-YYYY'); i = i.add(1, 'day')) {
            let total = 0;
            let ordersByDay = orders.filter((order) => dayjs(order.createdAt).format('DD-MM-YYYY') === i.format('DD-MM-YYYY'));
            ordersByDay.forEach((order) => {
                order.items.forEach((item) => {
                    total += item.item.price * item.quantity;
                });
            });
            result.push({ date: i.format('DD-MM-YYYY'), total: total });
        }


        return res.status(StatusCodes.OK).json({ result });
    }
    catch (error) {
        console.log(error);
        return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};



module.exports = {
    getNumberOfOrders,
    getNumberOfOrdersByWaiter,
    getTotalforWaiter
};