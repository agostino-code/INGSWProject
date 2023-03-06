const express = require('express');
const { checkToken } = require('../middleware/middleware');

const router = express.Router();

router.route("/check").get(checkToken, (req, res) => {
    res.status(200).json({
        success: true,
        message: "Token valido!"
    });
});

router.route("/").get((req, res) => {
    res.status(200).json({ msg: "Middleware route" });
});

module.exports = router;