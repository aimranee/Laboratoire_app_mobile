const express = require("express");
const admin = require("./admin");
const client = require("./patient");
// import response from "../helpers/response";

const routes = express.Router();

// routes.use(response.setHeadersForCORS);

routes.use("/admin", admin);
routes.use("/patient", client);

module.exports = routes;