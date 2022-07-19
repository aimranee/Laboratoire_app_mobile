const db = require("../db/db");

exports.get_notif_status_admin = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query(
      "SELECT isAnyNotification FROM admin WHERE uId = ?",
      [req.params.uId],
      (err, rows) => {
        connection.release();
        if (!err) res.send(rows);
        else console.log(err);

        // console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.update_notif_status_admin = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE admin SET isAnyNotification = ?",
      [params.isAnyNotification],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`success`);
        else console.log(err);

        // console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.get_notif_status_patient = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query(
      "SELECT isAnyNotification FROM patient WHERE uId = ?",
      [req.params.uId],
      (err, rows) => {
        connection.release();
        if (!err) res.send(rows);
        else console.log(err);

        // console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.update_notif_status_patient = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE patient SET isAnyNotification = ? WHERE uId = ?",
      [params.isAnyNotification, params.uId],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`success`);
        else console.log(err);

        // console.log("The data from user table \n", rows);
      }
    );
  });
};

