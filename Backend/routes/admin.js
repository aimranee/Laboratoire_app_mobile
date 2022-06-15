const express = require("express");

const routes = express.Router();

// routes.use(response.setHeadersForCORS);

routes.use("/", (req, res) => {
  res.send(`hhhhhhhhhh`);
  console.log("test admin");
});

module.exports = routes;
