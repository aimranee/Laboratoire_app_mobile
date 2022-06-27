const express = require("express");
const adminController = require("../controllers/adminContoller");
const availabilityController = require("../controllers/availabilityController");
const routes = express.Router();

routes.route("/signup").post(adminController.signup);
routes.route("/login").post(adminController.login);
routes.route("/get_user/:uId").get(adminController.get_user);
routes.route("/update_user").put(adminController.update_user);
routes.route("/update_user_fcm").put(adminController.update_user_fcm);

routes.route("/get_availability").get(availabilityController.get_availability);
routes
  .route("/update_availability")
  .put(availabilityController.update_availability);

routes.route("/get_all_user").get(adminController.get_all_user);
module.exports = routes;
