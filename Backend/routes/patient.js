const express = require("express");
const availabilityController = require("../controllers/availabilityController");

const routes = express.Router();

// routes.use(response.setHeadersForCORS);

// routes.use("/", (req, res) => {
//   console.log("test client");
// });

routes.route("/get_availability").get(availabilityController.get_availability);

module.exports = routes;
