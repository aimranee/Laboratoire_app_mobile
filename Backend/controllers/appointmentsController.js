const db = require("../db/db");

exports.add_appointment = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query("INSERT INTO appointments SET ?", params, (err, rows) => {
      connection.release();
      if (!err) res.send(`Bien Enregistrer!!`);
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
        if (!err) res.send(`Bien Enregistrer!!`);
        else console.log(err);

        console.log("The data from appointments table \n", rows);
      }
    );
  });
};
