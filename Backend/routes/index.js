const express = require("express");
const admin = require("./admin");
const client = require("./patient");

const routes = express.Router();

routes.use("/admin", admin);
routes.use("/patient", client);

module.exports = routes;