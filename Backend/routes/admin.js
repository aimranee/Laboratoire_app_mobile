const express = require("express");

const routes = express.Router();

// routes.use(response.setHeadersForCORS);
app.use('/auth',Autorization)

routes.use("/", (req, res) => {
  res.send(`hhhhhhhhhh`);
  console.log("test admin");
});

module.exports = routes;
