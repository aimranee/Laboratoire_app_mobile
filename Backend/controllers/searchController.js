const db = require("../db/db");

exports.search_by_CIN = function (req, res) {
    db.getConnection((err, connection) => {
        if (err) throw err;
        connection.query(
          "SELECT appointments.*, patient.cin FROM appointments LEFT JOIN patient ON appointments.uId = patient.uId WHERE LOWER(patient.cin) = ? ORDER BY createdTimeStamp DESC",
          [req.params.cin],
          (err, rows) => {
            connection.release();
            if (!err) res.send(rows);
            else console.log(err);
            // console.log("The data from user table \n", rows);
          }
        );
    })
};
