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
            from: `"Vault Guard 🔐" <${process.env.EMAIL_USER}>`,
            to: email,
            subject: "Your Vault OTP 🔐",
            html: `
    <div style="font-family: Arial, sans-serif; background:#f4f4f4; padding:20px;">
        <div style="max-width:500px; margin:auto; background:white; padding:20px; border-radius:10px; text-align:center;">

            <img src="https://cdn-icons-png.flaticon.com/512/3064/3064197.png"
                 width="80"
                 style="margin-bottom:10px;" />

            <h2 style="color:#333;">Vault Guard OTP</h2>

            <p style="font-size:16px; color:#555;">
                Use the OTP below to unlock your vault. It is valid for 5 minutes.
            </p>

            <div style="font-size:28px; font-weight:bold; letter-spacing:5px; color:#000; margin:20px 0;">
                ${otp}
            </div>

            <p style="color:red; font-size:13px;">
                Do not share this OTP with anyone.
            </p>

            <hr />

            <p style="font-size:12px; color:#888;">
                If you didn’t request this, ignore this email.
            </p>

        </div>
    </div>
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
const Vault = require("../models/vault.model");
const Otp = require("../models/otp.model");

const verifyOtp = async (req, res) => {
    try {
        const { email, otp, vaultId } = req.body;

        if (!email || !otp || !vaultId) {
            return res.status(400).json({
                success: false,
                message: "Email, OTP and vaultId required",
            });
        }

        // 1. CHECK OTP
        const otpData = await Otp.findOne({
            email,
            otp,
        }).sort({ createdAt: -1 });

        if (!otpData) {
            return res.status(400).json({
                success: false,
                message: "Invalid OTP",
            });
        }

        if (otpData.expiresAt < new Date()) {
            return res.status(400).json({
                success: false,
                message: "OTP expired",
            });
        }

        // 2. FIND VAULT
        const vault = await Vault.findById(vaultId);

        if (!vault) {
            return res.status(404).json({
                success: false,
                message: "Vault not found",
            });
        }

        // 3. UNLOCK VAULT
        vault.isUnlocked = true;
        vault.status = "unlocked";

        await vault.save();

        // OPTIONAL: delete OTP after success
        await Otp.deleteMany({ email });

        return res.status(200).json({
            success: true,
            message: "Vault unlocked successfully",
            data: vault,
        });

    } catch (error) {
        console.log(error);
        return res.status(500).json({
            success: false,
            message: "Failed to verify OTP",
        });
    }
};

module.exports = {
    sendOtp,
    verifyOtp,
};
