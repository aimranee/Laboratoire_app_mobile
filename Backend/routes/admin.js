const express = require("express");
const adminController = require("../controllers/adminContoller");
const availabilityController = require("../controllers/availabilityController");
const appointmentsController = require("../controllers/appointmentsController");
const analysesController = require("../controllers/analysesController");
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
  .route("/get_all_appointment/:status/:type/:firstDate/:lastDate/:limit")
  .get(appointmentsController.get_all_appointment);
routes
  .route("/get_appointment_type")
  .get(appointmentsController.get_appointment_type);
routes.route("/add_appointment").post(appointmentsController.add_appointment);

routes.route("/get_analyses").get(analysesController.get_analyses);
routes
  .route("/get_analyses_byId/:id")
  .get(analysesController.get_analyses_byId);
routes.route("/get_categories").get(analysesController.get_categories);
routes.route("/get_cat_analyse").get(analysesController.get_cat_analyse);
routes
  .route("/get_appointment_by_status/:uId/:status")
  .get(appointmentsController.get_appointment_by_status);
module.exports = routes;
