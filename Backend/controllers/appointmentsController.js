const db = require("../db/db");

exports.add_appointment = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query("INSERT INTO appointments SET ?", params, (err, rows) => {
      connection.release();
      if (!err) res.send(`success`);
      else console.log(err);

      console.log("The data from appointments table \n", rows);
    });
  });
};

exports.get_appointment_by_status = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    // const params = req.body;
    const str = req.params.status;
    console.log(str);
    const arr = str.split(",");
    console.log("loste : " + arr);

    connection.query(
      "SELECT * FROM appointments WHERE uId = ? AND appointmentStatus IN (?)",
      [req.params.uId, arr],
      (err, rows) => {
        connection.release();
        if (!err) res.send(rows);
        else console.log(err);

        console.log("The data from appointments table \n", rows);
      }
    );
  });
};

exports.get_appointment_type = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query("SELECT * FROM appointmenttype", (err, rows) => {
      connection.release();
      if (!err) {
        res.send(rows);
      } else {
        console.log(err);
      }

      console.log("the data from appointmenttype table are : \n", rows);
    });
  });
};

exports.update_appointment_status = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE appointments SET appointmentStatus = ? WHERE id = ?",
      [params.appointmentStatus, params.id],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`success`);
        else console.log(err);
        console.log("The data from appointments table \n", rows);
      }
    );
  });
};

exports.get_appointment_by_Uid = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query(
      "SELECT appointments.*, patient.cin FROM appointments LEFT JOIN patient ON appointments.uId = patient.uId WHERE appointments.uId = ?",
      [req.params.uId],
      (err, rows) => {
        connection.release();
        if (!err) res.send(rows);
        else console.log(err);

        console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.get_all_appointment = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    params = req.params;

    console.log("first" + params.status);
    const str1 = params.status;
    const arr1 = str1.split(",");
    console.log("res : " + arr1);

    const str2 = params.type;
    const arr2 = str2.split(",");
    console.log("res : " + arr2);

    if (params.firstDate == "All" && params.lastDate == "All") {
      connection.query(
        `SELECT appointments.*, patient.cin FROM appointments LEFT JOIN patient ON appointments.uId = patient.uId WHERE appointmentStatus IN (?) AND appointmentType IN (?) LIMIT ${params.limit}`,
        [arr1, arr2, params.limit],
        (err, rows) => {
          connection.release();
          if (!err) res.send(rows);
          else console.log(err);

          console.log("The data from user table \n", rows);
        }
      );
    } else {
      connection.query(
        "SELECT * FROM appointments WHERE appointmentStatus IN (?) AND 	appointmentType IN (?) AND appointmentDate >= ? AND appointmentDate <= ? LIMIT ?",
        [],
        (err, rows) => {
          connection.release();
          if (!err) res.send(rows);
          else console.log(err);

          console.log("The data from user table \n", rows);
        }
      );
    }
  });
};
