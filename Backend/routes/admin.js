const express = require("express");
const adminController = require("../controllers/adminContoller");
const availabilityController = require("../controllers/availabilityController");
const appointmentsController = require("../controllers/appointmentsController");
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

routes
  .route("/get_appointment_by_Uid/:uId")
  .get(appointmentsController.get_appointment_by_Uid);
routes
  .route("/update_appointment_status")
  .put(appointmentsController.update_appointment_status);

routes
  .route("/get_appointment_type")
  .get(appointmentsController.get_appointment_type);

routes
  .route(
    "/get_all_appointment/:status/:type/:firstDate/:lastDate/:limit"
  )
  .get(appointmentsController.get_all_appointment);

module.exports = routes;
