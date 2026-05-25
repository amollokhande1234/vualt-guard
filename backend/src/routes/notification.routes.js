const express = require("express");
const router = express.Router();

const {
    getMyNotifications,
    markAsRead,
    markAllAsRead,
    deleteNotification
} = require("../controllers/notication.controller");

const requireAuth = require("../middleware/requireAuth"); // adjust path if needed

// GET ALL NOTIFICATIONS
router.get("/", requireAuth, getMyNotifications);

// MARK SINGLE NOTIFICATION AS READ
router.patch("/:id/read", requireAuth, markAsRead);

// MARK ALL AS READ
router.patch("/read-all", requireAuth, markAllAsRead);

// DELETE NOTIFICATION
router.delete("/:id", requireAuth, deleteNotification);

module.exports = router;