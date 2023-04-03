const { StatusCodes } = require("http-status-codes");
const Admin = require('../models/admin.model');
const Restaurant = require('../models/restaurant.model');
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const adminSignUp = async (req, res) => {
   const { name, surname, email, password, firstlogin } = req.body;
   try {
      if (!name || !surname || !email || !password || !firstlogin) {
         return res.status(StatusCodes.BAD_REQUEST).json({
            error: "Per favore inserisci tutte le informazioni richieste!",
         });
      }

      const hash_password = await bcrypt.hash(password, 10);

      const adminData = {
         name,
         surname,
         email,
         hash_password
      };

      const admin = await Admin.findOne({ email });
      if (admin) {
         return res.status(StatusCodes.BAD_REQUEST).json({
            error: "L'amministratore è già registrato!",
         });
      } else {
         Admin.create(adminData).then((data, err) => {
            if (err) return res.status(StatusCodes.BAD_REQUEST).json({ err });
            else
               return res.status(StatusCodes.CREATED)
                  .json({ error: "Amministatore creato correttamente." });
         });
      }
   } catch (error) {
      console.log(error);
      return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

const adminSignIn = async (req, res) => {
   const { email, password } = req.body;
   try {
      if (!email || !password) {
         return res.status(StatusCodes.BAD_REQUEST).json({
            error: "Per favore inserisci email e password!",
         });
      }

      const admin = await Admin.findOne({ email: email });

      // admin = {
      //    _id: admin._id,
      //    name: admin.name,
      //    surname: admin.surname,
      //    email: admin.email,
      //    role: admin.role,
      //    firstlogin: admin.firstlogin
      // }

      if (admin) {
         if (await admin.authenticate(password)) {
            const token = jwt.sign(
               { _id: admin._id, role: admin.role },
               process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });
            const { _id, email, fullName } = admin;
            return res.status(StatusCodes.OK).json({
               token,
               admin,
            });
         } else {
            return res.status(StatusCodes.UNAUTHORIZED).json({
               error: "Qualcosa è andato storto, controlla la tua password!",
            });
         }
      } else {
         return res.status(StatusCodes.BAD_REQUEST).json({
            error: "L'amministratore non esiste, controlla la tua email!",
         });
      }
   } catch (error) {
      console.log(error);
      return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

const getRestaurants = async (req, res) => {
   try {
      const restaurants = await Restaurant.find({ owner: req.decoded._id });
      if (!restaurants) {
         return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
      }
      res.status(StatusCodes.OK).json({ restaurants });
   } catch (error) {
      console.log(error);
      res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

const deleteRestaurant = async (req, res) => {
   try {
      if (!req.body.name) return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Ristorante non trovato!' });

      if (req.decoded.role !== 'admin') {
         return res.status(StatusCodes.UNAUTHORIZED).json({ error: 'Non sei autorizzato!' });
      }
      const restaurant = Restaurant.findOne({ name: req.body.name, owner: req.decoded._id });
      if (!restaurant) {
         return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Ristorante non trovato!' });
      }
      await restaurant.remove();
      res.status(StatusCodes.OK).json({ msg: 'Ristorante eliminato con successo.' });
   } catch (error) {
      console.log(error);
      res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

const changePassword = async (req, res) => {
   try {
      const admin = await Admin.findById(req.decoded._id);
      if (!admin) {
         return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Amministratore non trovato!' });
      }
      const { oldPassword, newPassword, firstlogin } = req.body;
      if (await admin.authenticate(oldPassword)) {
         const hash_password = await bcrypt.hash(newPassword, 10);
         admin.hash_password = hash_password;
         admin.firstlogin = firstlogin;
         await admin.save();
         res.status(StatusCodes.OK).json({ admin });
      } else {
         return res.status(StatusCodes.UNAUTHORIZED).json({
            error: "Qualcosa è andato storto, controlla la tua vecchia password!",
         });
      }
   } catch (error) {
      console.log(error);
      res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

module.exports = {
   getRestaurants,
   deleteRestaurant,
   adminSignIn,
   adminSignUp,
   changePassword
};