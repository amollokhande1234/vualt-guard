const otpGenerator = require("otp-generator");

const transporter = require("../config/nodemailer");

const Otp = require("../models/otp.model");

const User = require("../models/user.model");

// SEND OTP
const sendOtp = async (req, res) => {
    try {
        const { email } = req.body;

        // Check email
        if (!email) {

            return res.status(400).json({
                success: false,
                message: "Email is required.",
            });
        }

        // Check user exists
        const user = await User.findOne({
            email,
        });

        if (!user) {

            return res.status(404).json({
                success: false,
                message: "User not found.",
            });
        }

        // Generate OTP
        const otp = otpGenerator.generate(
            6,
            {
                upperCaseAlphabets: false,
                lowerCaseAlphabets: false,
                specialChars: false,
            }
        );

        // Save OTP
        await Otp.create({

            email,

            otp,

            expiresAt:
                new Date(Date.now() + 5 * 60 * 1000),
        });

        // Send Mail
        await transporter.sendMail({

            from: process.env.EMAIL_USER,

            to: email,

            subject: "Vault Unlock OTP",

            html: `
                <h2>Your OTP</h2>
                <h1>${otp}</h1>
                <p>This OTP will expire in 5 minutes.</p>
            `,
        });

        return res.status(200).json({

            success: true,

            message:
                "OTP sent successfully.",
        });

    } catch (error) {

        console.log("Send OTP Error:", error);

        return res.status(500).json({

            success: false,

            message:
                "Failed to send OTP.",
        });
    }
};

// VERIFY OTP
const verifyOtp = async (req, res) => {

    try {

        const { email, otp } = req.body;

        // Check fields
        if (!email || !otp) {

            return res.status(400).json({
                success: false,
                message:
                    "Email and OTP are required.",
            });
        }

        // Find latest OTP
        const otpData =
            await Otp.findOne({
                email,
                otp,
            }).sort({
                createdAt: -1,
            });

        // OTP not found
        if (!otpData) {

            return res.status(400).json({
                success: false,
                message:
                    "Invalid OTP.",
            });
        }

        // Check expiry
        if (
            otpData.expiresAt < new Date()
        ) {

            return res.status(400).json({
                success: false,
                message:
                    "OTP expired.",
            });
        }

        // Success
        return res.status(200).json({

            success: true,

            message:
                "OTP verified successfully.",
        });

    } catch (error) {

        console.log(
            "Verify OTP Error:",
            error
        );

        return res.status(500).json({

            success: false,

            message:
                "Failed to verify OTP.",
        });
    }
};

module.exports = {
    sendOtp,
    verifyOtp,
};
