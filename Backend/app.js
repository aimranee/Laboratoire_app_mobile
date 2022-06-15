const express = require("express");
// const bodyParser = require("body-parser");
// const mysql = require("mysql");
const app = express();
const port = process.env.PORT || 5000;
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
const routes = require("./routes");

// const pool = mysql.createPool({
//   connectionLimit: 10,
//   host: "localhost",
//   user: "root",
//   password: "",
//   database: "syslab",
// });

app.use("/api", routes);

// app.get("/get_analyses", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     connection.query("SELECT * FROM analyses", (err, rows) => {
//       connection.release();
//       if (!err) {
//         res.send(rows);
//       } else {
//         console.log(err);
//       }

//       console.log("the data from analyses table are : \n", rows);
//     });
//   });
// });

// app.get("/get_analyses_byId/:id", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     connection.query(
//       "SELECT * FROM analyses WHERE category_id = ?",
//       [req.params.id],
//       (err, rows) => {
//         connection.release();
//         if (!err) {
//           res.send(rows);
//         } else {
//           console.log(err);
//         }

//         console.log("the data from analyses table are : \n", rows);
//       }
//     );
//   });
// });

// app.post("/add_appointment", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     const params = req.body;
//     connection.query("INSERT INTO appointments SET ?", params, (err, rows) => {
//       connection.release();
//       if (!err) res.send(`Bien Enregistrer!!`);
//       else console.log(err);

//       console.log("The data from appointments table \n", rows);
//     });
//   });
// });

// // app.get("/get_appointment_by_status", (req, res) => {
// //   pool.getConnection((err, connection) => {
// //     if (err) throw err;
// //     const params = req.body;
// //     connection.query(
// //       "SELECT * FROM appointments WHERE uId = ? AND appointmentStatus = ?",
// //       params,
// //       (err, rows) => {
// //         connection.release();
// //         if (!err) res.send(`Bien Enregistrer!!`);
// //         else console.log(err);

// //         console.log("The data from appointments table \n", rows);
// //       }
// //     );
// //   });
// // });

// app.get("/get_appointment_type", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     connection.query("SELECT * FROM appointmenttype", (err, rows) => {
//       connection.release();
//       if (!err) {
//         res.send(rows);
//       } else {
//         console.log(err);
//       }

//       console.log("the data from appointmenttype table are : \n", rows);
//     });
//   });
// });

// app.get("/get_cat_analyse", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     connection.query("SELECT id, name, price FROM analyses", (err, rows) => {
//       connection.release();
//       if (!err) {
//         res.send(rows);
//       } else {
//         console.log(err);
//       }

//       console.log("the data from analyses table are : \n", rows);
//     });
//   });
// });

// app.get("/get_categories", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     connection.query("SELECT * FROM categories", (err, rows) => {
//       connection.release();
//       if (!err) {
//         res.send(rows);
//       } else {
//         console.log(err);
//       }

//       console.log("the data from categories table are : \n", rows);
//     });
//   });
// });

// app.get("/get_analyses_byId/:id", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     connection.query(
//       "SELECT * FROM analyses WHERE category_id = ?",
//       [req.params.id],
//       (err, rows) => {
//         connection.release();
//         if (!err) {
//           res.send(rows);
//         } else {
//           console.log(err);
//         }

//         console.log("the data from analyses table are : \n", rows);
//       }
//     );
//   });
// });

// app.get("/get_prescription_byid", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     const params = req.body;
//     connection.query(
//       "SELECT * FROM prescription where patientId = ? AND appointmentId = ? ORDER BY createdTimeStamp DESC",
//       [params.uId, params.appointmentId],
//       (err, rows) => {
//         connection.release();
//         if (!err) {
//           res.send(rows);
//         } else {
//           console.log(err);
//         }

//         console.log("the data from prescription table are : \n", rows);
//       }
//     );
//   });
// });

// app.post("/add_user", (req, res) => {
//   pool.getConnection((err, connection) => {
//     if (err) throw err;
//     const params = req.body;
//     console.log(`ìd : ${params.id}`);
//     connection.query("INSERT INTO patient SET ?", params, (err, rows) => {
//       connection.release();
//       if (!err) res.send(`Bien Enregistrer!! ID : ${params.uId} bien`);
//       else console.log(err);

//       console.log("The data from user table \n", rows);
//     });
//   });
// });

app.listen(port, () => console.log(`Listening on port ${port}`));
module.exports = app;