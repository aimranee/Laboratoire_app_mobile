const db = require("../db/db");

exports.get_prescription_byid = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "SELECT * FROM prescription where patientId = ? AND appointmentId = ? ORDER BY createdTimeStamp DESC",
      [params.uId, params.appointmentId],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(rows);
        } else {
          console.log(err);
        }
        console.log("the data from prescription table are : \n", rows);
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
        console.log("the data from prescription table are : \n", rows);
      }
    );
  });
};

exports.update_prescription_isPaied = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE prescription SET isPaied = ? WHERE id = ?",
      [params.isPaied, params.id],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(rows);
        } else {
          console.log(err);
        }
        console.log("the data from prescription table are : \n", rows);
      }
    );
  });
};
