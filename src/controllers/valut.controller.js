const Vault = require("../models/valut.model");
const cloudinary = require("../config/cloudinary");


// CREATE VAULT
const createVault = async (req, res) => {

    try {

        const {
            title,
            description,
            vaultType,
            unlockMethod,
            unlockDate,
            nomineeUserId,
            latitude,
            longitude,
            radiusInMeters,
        } = req.body || {};

        // ===============================
        // BASIC VALIDATIONS
        // ===============================

        // Title
        if (!title || title.trim() === "") {

            return res.status(400).json({
                success: false,
                message: "Vault title is required.",
            });
        }

        // Vault type
        if (!vaultType) {

            return res.status(400).json({
                success: false,
                message:
                    "Please select vault type.",
            });
        }

        // Allowed vault types
        const allowedVaultTypes = [
            "public",
            "private",
        ];

        if (
            !allowedVaultTypes.includes(vaultType)
        ) {

            return res.status(400).json({
                success: false,
                message:
                    "Invalid vault type selected.",
            });
        }

        // Unlock date
        if (!unlockDate) {

            return res.status(400).json({
                success: false,
                message:
                    "Unlock date is required.",
            });
        }

        // Parse date
        const parsedUnlockDate =
            new Date(unlockDate);

        // Invalid date
        if (
            isNaN(parsedUnlockDate.getTime())
        ) {

            return res.status(400).json({
                success: false,
                message:
                    "Invalid unlock date format.",
            });
        }

        // Future date check
        if (
            parsedUnlockDate <= new Date()
        ) {

            return res.status(400).json({
                success: false,
                message:
                    "Unlock date must be a future date.",
            });
        }

        // Files required
        if (
            !req.files ||
            req.files.length === 0
        ) {

            return res.status(400).json({
                success: false,
                message:
                    "Please upload at least one file.",
            });
        }

        // Max files
        if (req.files.length > 5) {

            return res.status(400).json({
                success: false,
                message:
                    "Maximum 5 files allowed.",
            });
        }

        // ===============================
        // PRIVATE VAULT VALIDATION
        // ===============================

        if (vaultType === "private") {

            // Unlock method required
            if (!unlockMethod) {

                return res.status(400).json({
                    success: false,
                    message:
                        "Please select one unlock method.",
                });
            }

            // Allowed unlock methods
            const allowedUnlockMethods = [
                "otp",
                "biometric",
                "location",
            ];

            if (
                !allowedUnlockMethods.includes(
                    unlockMethod
                )
            ) {

                return res.status(400).json({
                    success: false,
                    message:
                        "Invalid unlock method selected.",
                });
            }

            // Location validation
            if (
                unlockMethod === "location"
            ) {

                if (
                    !latitude ||
                    !longitude
                ) {

                    return res.status(400).json({
                        success: false,
                        message:
                            "Latitude and longitude are required.",
                    });
                }

                if (!radiusInMeters) {

                    return res.status(400).json({
                        success: false,
                        message:
                            "Radius is required for location unlock.",
                    });
                }
            }
        }

        // ===============================
        // FILE UPLOAD
        // ===============================

        let uploadedFiles = [];

        for (const file of req.files) {

            const result =
                await cloudinary.uploader.upload(
                    file.path,
                    {
                        folder: "vault_files",
                        resource_type: "auto",
                    }
                );

            uploadedFiles.push({

                originalName:
                    file.originalname,

                fileUrl:
                    result.secure_url,

                publicId:
                    result.public_id,

                type:
                    file.mimetype,

                size:
                    file.size,
            });
        }

        // ===============================
        // CREATE VAULT
        // ===============================

        const vault =
            await Vault.create({

                ownerId: req.user.id,

                title: title.trim(),

                description,

                files: uploadedFiles,

                vaultType,

                unlockMethod:
                    vaultType === "private"
                        ? unlockMethod
                        : null,

                unlockDate:
                    parsedUnlockDate,

                allowedLocation:
                    unlockMethod === "location"
                        ? {
                            latitude,
                            longitude,
                            radiusInMeters,
                        }
                        : undefined,

                nominee:
                    nomineeUserId
                        ? {
                            nomineeUserId,
                            unlockDate:
                                parsedUnlockDate,
                        }
                        : undefined,

                status: "locked",
            });

        // ===============================
        // SUCCESS RESPONSE
        // ===============================

        return res.status(201).json({

            success: true,

            message:
                "Vault created successfully.",

            data: vault,
        });

    } catch (error) {

        console.log(
            "Create Vault Error:",
            error
        );

        return res.status(500).json({

            success: false,

            message:
                "Something went wrong while creating the vault.",
        });
    }
};

// GET ALL VAULTS
const getMyVaults = async (req, res) => {
    try {
        const vaults = await Vault.find({
            ownerId: req.user.id,
        }).sort({ createdAt: -1 });

        return res.status(200).json({
            success: true,
            data: vaults,
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Failed to fetch vaults",
        });
    }
};

// GET SINGLE VAULT
const getSingleVault = async (req, res) => {
    try {
        const vault = await Vault.findById(req.params.id);

        if (!vault) {
            return res.status(404).json({
                success: false,
                message: "Vault not found",
            });
        }

        // CHECK UNLOCK DATE
        const currentDate = new Date();

        if (currentDate < vault.unlockDate) {
            return res.status(403).json({
                success: false,
                message: "Vault is still locked",
            });
        }

        vault.isUnlocked = true;
        vault.status = "unlocked";

        await vault.save();

        return res.status(200).json({
            success: true,
            data: vault,
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Failed to fetch vault",
        });
    }
};

// UPDATE VAULT
const updateVault = async (req, res) => {
    try {
        const vault = await Vault.findById(req.params.id);

        if (!vault) {
            return res.status(404).json({
                success: false,
                message: "Vault not found",
            });
        }

        // OWNER CHECK
        if (vault.ownerId.toString() !== req.user.id) {
            return res.status(403).json({
                success: false,
                message: "Unauthorized",
            });
        }

        const updatedVault = await Vault.findByIdAndUpdate(
            req.params.id,
            req.body,
            {
                new: true,
            }
        );

        return res.status(200).json({
            success: true,
            message: "Vault updated successfully",
            data: updatedVault,
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Failed to update vault",
        });
    }
};

// DELETE VAULT
const deleteVault = async (req, res) => {
    try {
        const vault = await Vault.findById(req.params.id);

        if (!vault) {
            return res.status(404).json({
                success: false,
                message: "Vault not found",
            });
        }

        if (vault.ownerId.toString() !== req.user.id) {
            return res.status(403).json({
                success: false,
                message: "Unauthorized",
            });
        }

        await Vault.findByIdAndDelete(req.params.id);

        return res.status(200).json({
            success: true,
            message: "Vault deleted successfully",
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Failed to delete vault",
        });
    }
};

// UNLOCK VAULT
const unlockVault = async (req, res) => {
    try {
        const { vaultId, otp, biometricVerified } = req.body;

        const vault = await Vault.findById(vaultId);

        if (!vault) {
            return res.status(404).json({
                success: false,
                message: "Vault not found",
            });
        }

        const currentDate = new Date();

        // CHECK DATE
        if (currentDate < vault.unlockDate) {
            return res.status(403).json({
                success: false,
                message: "Unlock date not reached",
            });
        }

        // OTP CHECK
        if (vault.unlockConditions.otpVerification) {
            if (!otp) {
                return res.status(400).json({
                    success: false,
                    message: "OTP required",
                });
            }
        }

        // BIOMETRIC CHECK
        if (vault.unlockConditions.biometricVerification) {
            if (!biometricVerified) {
                return res.status(400).json({
                    success: false,
                    message: "Biometric verification required",
                });
            }
        }

        vault.isUnlocked = true;
        vault.status = "unlocked";

        await vault.save();

        return res.status(200).json({
            success: true,
            message: "Vault unlocked successfully",
            data: vault,
        });
    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Failed to unlock vault",
        });
    }
};

module.exports = {
    createVault,
    getMyVaults,
    getSingleVault,
    updateVault,
    deleteVault,
    unlockVault,
};