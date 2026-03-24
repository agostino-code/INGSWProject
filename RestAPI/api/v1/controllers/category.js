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
        //count menucategory
        const temp = await MenuCategory.find({ restaurant: req.body.restaurant });
        index=0;
        temp.forEach(element => {
            index++;
        });
        const category = new MenuCategory({ name: req.body.name, restaurant: req.body.restaurant, index: index });
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
        const categories = await MenuCategory.find({ restaurant: req.body.restaurant }).sort({index:1});
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
        const category = await MenuCategory.findById(req.body.category);
        if (!category) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Categoria non trovata!' });
        }
        restaurant = category.restaurant;
        await category.remove();
        const temp = await MenuCategory.find({ restaurant: restaurant }).sort({index:1});
        index=0;
        temp.forEach(element => {
            element.index = index;
            index++;
            element.save();
        });

        res.status(StatusCodes.OK).json({ msg: 'Categoria eliminata!' });
        
    }catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }  
};

const updateIndexCategory = async (req, res) => {
    try {
        if(req.decoded.role !== 'admin' && req.decoded.role !== 'supervisor') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        if(req.body.index < 0){
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Indice non valido!' });
        }

        var category = await MenuCategory.findOne({_id: req.body.category});
        if (!category) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Categoria non trovata!' });
        }
        if(req.body.index != category.index){
            if(req.body.index > category.index){
                var temp = await MenuCategory.find({ restaurant: category.restaurant, index: { $gte: category.index, $lte: req.body.index } }).sort({index:1});
                temp.forEach(element => {
                    if(element._id != req.body.category){
                        element.index = element.index - 1;
                        element.save();
                    }
                }
            )};
            if(req.body.index < category.index){
                var temp = await MenuCategory.find({ restaurant: category.restaurant, index: { $gte: req.body.index, $lte: category.index } }).sort({index:1});
                temp.forEach(element => {
                    if(element._id != req.body.category){
                        element.index = element.index + 1;
                        element.save();
                    }
                }
            );
        }

        category.index = req.body.index;
        await category.save();

        res.status(StatusCodes.OK).json({ msg: 'Categoria aggiornata!' });
    }
    }catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};


module.exports = {
    newMenuCategory,
    getMenuCategories,
    deleteMenuCategory,
    updateIndexCategory
};