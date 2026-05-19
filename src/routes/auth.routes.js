const express = require("express");

const router = express.Router();

const authController =
    require("../controllers/auth.controller");

const {
    verifyToken
} = require("../middlewares/auth.middleware");


// Public Routes
router.post('/register', authController.register);

router.post('/login', authController.login);


// OTP Routes
router.post("/send-otp", authController.sendOTP);

router.post("/verify-otp", authController.verifyOTP);

module.exports = router;