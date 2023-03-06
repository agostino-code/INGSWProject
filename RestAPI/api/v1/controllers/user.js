const { StatusCodes } = require('http-status-codes');
const User = require('../models/user.model');
const Restaurant = require('../models/restaurant.model');
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");

const userSignUp = async (req, res) => {
   const { name, surname, email, password, role, restaurant, firstlogin } = req.body;
   try {
      if (!name || !surname || !email || !password || !role || !restaurant || !firstlogin) {
         return res.status(StatusCodes.BAD_REQUEST).json({
            error: "Per favore inserisci tutte le informazioni richieste!",
         });
      }

      const hash_password = await bcrypt.hash(password, 10);

      const userData = {
         name,
         surname,
         email,
         hash_password,
         role,
         restaurant,
         firstlogin
      };

      const user = await User.findOne({ email });
      if (user) {
         return res.status(StatusCodes.BAD_REQUEST).json({
            error: "L'utente è già registrato!",
         });
      } else {
         User.create(userData).then((data, err) => {
            if (err) return res.status(StatusCodes.BAD_REQUEST).json({ err });
            else
               return res.status(StatusCodes.CREATED)
                  .json({ msg: "Utente creato correttamente." });
         });
      }
   } catch (error) {
      console.log(error);
      return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

const userSignIn = async (req, res) => {
   const { email, password } = req.body;
   try {
      if (!email || !password) {
         return res.status(StatusCodes.BAD_REQUEST).json({
            error: "Per favore inserisci email e password!",
         });
      }

      const user = await User.findOne({ email: email }).populate('restaurant');

      if (user) {
         if (await user.authenticate(password)) {
            const token = jwt.sign(
               { _id: user._id, role: user.role },
               process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });
            return res.status(StatusCodes.OK).json({
               token,
               user,
            });
         } else {
            return res.status(StatusCodes.UNAUTHORIZED).json({
               error: "Qualcosa è andato storto, controlla la tua password!",
            });
         }
      } else {
         return res.status(StatusCodes.BAD_REQUEST).json({
            error: "L'utente non esiste, controlla la tua email!",
         });
      }
   } catch (error) {
      console.log(error);
      return res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

const getRestaurant = async (req, res) => {
   try {
      const user = await User.findById(req.decoded._id).populate('restaurant');
      if (!user) {
         return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Utente non trovato!' });
      }
      res.status(StatusCodes.OK).json({ restaurant: user.restaurant});
   } catch (error) {
      console.log(error);
      res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

const setFirstLogin = async (req, res) => {
   try {
      const user= await User.findById(req.decoded._id);
      if (!user) {
         return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Utente non trovato!' });
      }
      user.firstlogin = false;
      await user.save();
      res.status(StatusCodes.OK);
   } catch (error) {
      console.log(error);
      res.status(StatusCodes.INTERNAL_SERVER_ERROR).json({ error });
   }
};

const changePassword = async (req, res) => {
   try {
      const user = await User.findById(req.decoded._id);
      if (!user) {
         return res.status(StatusCodes.BAD_REQUEST).json({ error: 'Utente non trovato!' });
      }
      const { oldPassword, newPassword } = req.body;
      if (await user.authenticate(oldPassword)) {
         const hash_password = await bcrypt.hash(newPassword, 10);
         user.hash_password = hash_password;
         await user.save();
         res.status(StatusCodes.OK).json({ user });
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
   setFirstLogin,
   getRestaurant,
   changePassword,
   userSignIn,
   userSignUp
};
