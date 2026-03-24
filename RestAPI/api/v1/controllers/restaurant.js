const { StatusCodes } = require("http-status-codes");
const Restaurant = require("../models/restaurant.model");
const MenuCategory = require("../models/category.model");
const Item = require("../models/item.model");
const TranslatedCategory = require("../models/translated.category.model");
const TranslatedItem = require("../models/translated.item.model");
const User = require("../models/user.model");

const newResturant = async (req, res) => {
    try {
        if (req.decoded.role !== 'admin') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }
        const finded = await Restaurant.findOne({ name: req.body.name, owner: req.decoded._id });
        if (finded) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Ristorante già esistente.' });
        }
        const restaurant = new Restaurant({ name: req.body.name, owner: req.decoded._id });
        await restaurant.save();
        res.status(StatusCodes.CREATED).json({ msg: 'È stato creato un nuovo ristorante.' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};

const translate = require('@iamtraction/google-translate');
const translate2 = require('bing-translate-api');

const generateTranslatedCategory = async (req, res) => {
    try {
        if (req.decoded.role !== 'admin') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }

        temptcategory = await TranslatedCategory.find({ restaurant: req.body.restaurant, language: req.body.language });
        temptcategory.forEach(async element => {
            await element.remove();
        });

        const categories = await MenuCategory.find({ restaurant: req.body.restaurant });
        if (!categories) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Errore!' });
        }

        categories.forEach(async category => {
            await translatecategory(category, req);
        });

        res.status(StatusCodes.CREATED).json({ msg: 'Categorie generate con successo.' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }

};

const generateTranslatedItem = async (req, res) => {
    try {
        if (req.decoded.role !== 'admin') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }

        temptitem = await TranslatedItem.find({ restaurant: req.body.restaurant, language: req.body.language });
        temptitem.forEach(async element => {
            await element.remove();
        });

        const categories = await TranslatedCategory.find({ restaurant: req.body.restaurant, language: req.body.language });
        if (!categories) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Errore!' });
        }

        categories.forEach(async category => {
            Item.find({ category: category.category }).then(async items => {
                items.forEach(async item => {
                    await itemtranslate(item, req, category);
                });
            });
        });

        res.status(StatusCodes.CREATED).json({ msg: 'Items generati con successo.' });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }

};

async function translatecategory(category, req) {
    category.name = category.name.toLowerCase();
    translate(category.name, { from: 'it', to: req.body.language }).then(async res => {
        tcname = res.text;
        tcname = tcname.charAt(0).toUpperCase() + tcname.slice(1);
        const translatedcategory = new TranslatedCategory({ name: tcname, restaurant: req.body.restaurant, language: req.body.language, index: category.index, category: category.id });
        await translatedcategory.save();
    });
}

async function itemtranslate(item, req, translatedcategory) {
    var tallergens = [];
    if (item.allergens) {
        item.allergens.forEach(async allergen => {
            if (allergen != '') {
                allergen = allergen.toLowerCase();
                translate(allergen, { from: 'it', to: req.body.language }).then(res => {
                    temp = res.text;
                    temp = temp.charAt(0).toUpperCase() + temp.slice(1);

                    tallergens.push(temp);
                });
            }
        });
    }
    var tides = '';
    if (item.description) {
        item.description = item.description.toLowerCase();
        translate(item.description, { from: 'it', to: req.body.language }).then(res => {
            tides = res.text;
            tides = tides.charAt(0).toUpperCase() + tides.slice(1);
        });
        if (tides == '') {
            translate2.translate(item.description, 'it', req.body.language).then(res => {
                tides = res.translation;
                tides = tides.charAt(0).toUpperCase() + tides.slice(1);
            });
        }
    }

    translate(item.name, { from: 'it', to: req.body.language }).then(async res => {
        tiname = res.text;
        tiname = tiname.charAt(0).toUpperCase() + tiname.slice(1);
        console.log(tiname, tides, tallergens);
        const translateditem = new TranslatedItem({ name: tiname, description: tides, allergens: tallergens, category: translatedcategory.id, restaurant: req.body.restaurant, language: req.body.language, index: item.index, price: item.price });
        await translateditem.save();
    });
    return true;
}

const getUserRestaurant = async (req, res) => {
    try {
        if (req.decoded.role !== 'admin') {
            return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
        }

        const users = await User.find({ restaurant: req.body.restaurant }).populate('restaurant');
        if (!users) {
            return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Non è stato trovato nessun utente!' });
        }

        res.status(StatusCodes.OK).json({ users });
    } catch (error) {
        console.log(error);
        res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
    }
};

module.exports = {
    newResturant,
    generateTranslatedCategory,
    generateTranslatedItem,
    getUserRestaurant,
};
