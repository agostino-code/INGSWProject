//Chech tocken validation return true or false middleware
const jwt = require('jsonwebtoken');
const { StatusCodes } = require('http-status-codes');

const checkToken = (req, res, next) => {
    let token = req.headers['x-access-token'] || req.headers['authorization']; // Express headers are auto converted to lowercase
    if (token.startsWith('Bearer ')) {
        // Remove Bearer from string
        token = token.slice(7, token.length);
    }
    if (token) {
        jwt.verify(token, process.env.JWT_SECRET, (error, decoded) => {
            if (error) {
                return res.status(StatusCodes.UNAUTHORIZED).json({
                    success: false,
                    error: 'Token non valido!'
                });
            } else {
                req.decoded = decoded;
                next();
            }
        });
    } else {
        return res.status(StatusCodes.UNAUTHORIZED).json({
            success: false,
            error: 'Hai bisogno di un token per accedere!'
        });
    }
};

module.exports = {
    checkToken: checkToken
};