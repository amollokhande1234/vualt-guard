const express = require('express')
const authRouter = require('./routes/auth.routes')
const fileRoutes = require("./routes/file.routes");
const valueRoutes = require("./routes/value.routes");
const otpRoutes = require("./routes/otp.routes");


const app = express();

app.use(express.json());
app.get('/', (req, res) => {
    console.log('Hello');
    res.send('API is running 🚀');
});

app.use('/api/auth', authRouter);

app.use("/api/files", fileRoutes);

app.use("/api/vault", valueRoutes);

app.use("/api/otp", otpRoutes);

module.exports = app;