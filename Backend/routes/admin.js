const express = require("express");
const adminController = require("../controllers/adminContoller");
const availabilityController = require("../controllers/availabilityController");
const appointmentsController = require("../controllers/appointmentsController");
const appointmentsTypeController = require("../controllers/appointmentsTypeController");
const analysesController = require("../controllers/analysesController");
const notificationController = require("../controllers/notificationController");
const prescriptionController = require("../controllers/prescriptionController");
const searchController = require("../controllers/searchController");

const routes = express.Router();

routes.route("/signup").post(adminController.signup);
routes.route("/login").post(adminController.login);
routes.route("/get_admin").get(adminController.get_admin);
routes.route("/update_admin_fcm").put(adminController.update_admin_fcm);
routes.route("/update_admin").put(adminController.update_admin);

routes.route("/get_user_fcm/:uId").get(adminController.get_user_fcm);
routes.route("/update_user").put(adminController.update_user);
routes.route("/get_all_user").get(adminController.get_all_user);

routes
  .route("/get_notif_status_admin/:uId")
  .get(notificationController.get_notif_status_admin);
routes
  .route("/update_notif_status_admin")
  .put(notificationController.update_notif_status_admin);

routes.route("/get_availability").get(availabilityController.get_availability);
routes
  .route("/update_availability")
  .put(availabilityController.update_availability);

routes
  .route("/get_appointment_by_Uid/:uId")
  .get(appointmentsController.get_appointment_by_Uid);
routes
  .route("/update_appointment_status")
  .put(appointmentsController.update_appointment_status);

routes
  .route("/get_appointment_type")
  .get(appointmentsTypeController.get_appointment_type);

routes
  .route("/get_all_appointment/:status/:type/:firstDate/:lastDate/:limit")
  .get(appointmentsController.get_all_appointment);

routes.route("/add_appointment").post(appointmentsController.add_appointment);

routes.route("/get_analyses").get(analysesController.get_analyses);
routes
  .route("/get_analyses_byId/:id")
  .get(analysesController.get_analyses_byId);
routes.route("/get_cat_analyse").get(analysesController.get_cat_analyse);
routes.route("/update_analyses").put(analysesController.update_analyses);
routes.route("/delete_analyses").delete(analysesController.delete_analyses);
routes.route("/add_analyses").post(analysesController.add_analyses);

routes.route("/get_categories").get(analysesController.get_categories);
routes
  .route("/get_categories_by_id/:id")
  .get(analysesController.get_categories_by_id);
routes.route("/update_categories").put(analysesController.update_categories);
routes.route("/delete_categories").delete(analysesController.delete_categories);
routes.route("/add_categories").post(analysesController.add_categories);

routes
  .route("/get_appointment_by_status/:uId/:status")
  .get(appointmentsController.get_appointment_by_status);

routes
  .route("/update_appointment_type")
  .put(appointmentsTypeController.update_appointment_type);

routes
  .route("/get_notif_status_patient/:uId")
  .get(notificationController.get_notif_status_patient);
routes
  .route("/update_notif_status_patient")
  .put(notificationController.update_notif_status_patient);
routes
  .route("/get_prescription/:uId")
  .get(prescriptionController.get_prescription);
routes
  .route("/get_prescription_byid/:uId/:appointmentId")
  .get(prescriptionController.get_prescription_byid);

routes
  .route("/update_prescription_status")
  .put(prescriptionController.update_prescription_status);

routes
  .route("/update_prescription")
  .put(prescriptionController.update_prescription);

routes.route("/add_prescription").post(prescriptionController.add_prescription);
routes
  .route("/delete_prescription")
  .delete(prescriptionController.delete_prescription);

routes
  .route("/delete_appointments")
  .delete(appointmentsController.delete_appointments);

routes
  .route("/search_appointment_by_CIN/:cin")
  .get(searchController.search_appointment_by_CIN);

routes
  .route("/search_patient_by_CIN/:cin")
  .get(searchController.search_patient_by_CIN);

module.exports = routes;

// const db = require("../db/db");

// const multer = require("multer");

// const storage = multer.diskStorage({
//   destination: (req, fileUrl, cb) => {
//     cb(null, "./uploads");
//   },
//   filename: (req, fileUrl, cb) => {
//     cb(null, Date.now() + "-" + fileUrl.originalname);
//   },
// });

// const upload = multer({
//   storage: storage,
// });

// //adding and update pdf
// routes
//   .route("/update_file", express.static(__dirname + "/uploads"))
//   .post(upload.single("file"), (req, res) => {
//     db.getConnection((err, connection) => {
//       if (err) throw err;
//       const params = req.body;
//       connection.query(
//         "UPDATE prescription SET fileUrl = ? WHERE id = ?",
//         [req.file.path, params.id],
//         (err, rows) => {
//           connection.release();
//           if (!err) {
//             res.send(`success`);
//           } else {
//             console.log(err);
//           }
//         }
//       );
//     });
//     // console.log(req.file.path);
//     // return res.send(req.file.path);
//   });
