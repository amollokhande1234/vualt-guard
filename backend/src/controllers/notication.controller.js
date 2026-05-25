const Notification = require("../models/notificatio.model");

// GET ALL NOTIFICATIONS
const getMyNotifications = async (req, res) => {
    try {
        const notifications = await Notification.find({
            userId: req.user.id,
        }).sort({ createdAt: -1 });

        return res.status(200).json({
            success: true,
            data: notifications,
        });

    } catch (error) {
        return res.status(500).json({
            success: false,
            message: "Failed to fetch notifications",
        });
    }
};


const markAsRead = async (req, res) => {
    try {
        const notification = await Notification.findOne({
            _id: req.params.id,
            userId: req.user.id,   // 🔐 IMPORTANT SECURITY FIX
        });

        if (!notification) {
            return res.status(404).json({
                success: false,
                message: "Notification not found",
            });
        }

        notification.isRead = true;
        await notification.save();

        return res.status(200).json({
            success: true,
            message: "Marked as read",
        });

    } catch (error) {
        return res.status(500).json({
            message: "Failed to update notification",
        });
    }
};

const markAllAsRead = async (req, res) => {
    try {
        await Notification.updateMany(
            { userId: req.user.id },
            { isRead: true }
        );

        return res.status(200).json({
            success: true,
            message: "All notifications marked as read",
        });

    } catch (error) {
        return res.status(500).json({
            message: "Failed to update notifications",
        });
    }
};

const deleteNotification = async (req, res) => {
    try {
        const notification = await Notification.findOneAndDelete({
            _id: req.params.id,
            userId: req.user.id,   // 🔐 prevent deletion of others
        });

        if (!notification) {
            return res.status(404).json({
                success: false,
                message: "Notification not found",
            });
        }

        return res.status(200).json({
            success: true,
            message: "Notification deleted",
        });

    } catch (error) {
        return res.status(500).json({
            message: "Failed to delete notification",
        });
    }
};


module.exports = {
    getMyNotifications,
    markAsRead,
    markAllAsRead,
    deleteNotification
};