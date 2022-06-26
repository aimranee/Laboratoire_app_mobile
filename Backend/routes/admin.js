const express = require("express");
const adminController = require("../controllers/adminContoller");
const routes = express.Router();

routes.route("/signup").post(adminController.signup);
routes.route("/login").post(adminController.login);
routes.route("/get_user/:uId").get(adminController.get_user);
routes.route("/update_user").put(adminController.update_user);
routes.route("/update_user_fcm").put(adminController.update_user_fcm);

module.exports = routes;
