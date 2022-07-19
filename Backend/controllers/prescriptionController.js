const db = require("../db/db");

exports.get_prescription_byid = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.params;
    connection.query(
      "SELECT * FROM prescription where patientId = ? AND appointmentId = ? ORDER BY updatedTimeStamp DESC",
      [params.uId, params.appointmentId],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(rows);
        } else {
          console.log(err);
        }
        // console.log("the data from prescription table are : \n", rows);
      }
    );
  });
};

exports.get_prescription = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    // const params = req.body;
    connection.query(
      "SELECT * FROM prescription WHERE patientId = ? ORDER BY createdTimeStamp DESC",
      [req.params.uId],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(rows);
        } else {
          console.log(err);
        }
        // console.log("the data from prescription table are : \n", rows);
      }
    );
  });
};

exports.update_prescription_isPaied = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE prescription SET isPaied = ?, updatedTimeStamp = ? WHERE id = ?",
      [params.isPaied, params.updatedTimeStamp, params.id],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(`success`);
        } else {
          console.log(err);
        }
        // console.log("the data from prescription table are : \n", rows);
      }
    );
  });
};

exports.update_prescription_status = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE prescription SET prescriptionStatus = ?, updatedTimeStamp = ? WHERE id = ?",
      [params.prescriptionStatus, params.updatedTimeStamp, params.id],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(`success`);
        } else {
          console.log(err);
        }
      }
    );
  });
};

exports.add_prescription = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query("INSERT INTO prescription SET ?", params, (err, rows) => {
      connection.release();
      if (!err) res.send(`success`);
      else console.log(err);

      // console.log("The data from prescription table \n", rows);
    });
  });
};

exports.delete_prescription = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "DELETE FROM prescription WHERE id = ?",
      [params.id],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`success`);
        else console.log(err);

        // console.log("The data from prescription table \n", rows);
      }
    );
  });
};
