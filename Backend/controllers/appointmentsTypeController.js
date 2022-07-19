const db = require("../db/db");

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

      // console.log("the data from appointmenttype table are : \n", rows);
    });
  });
};

exports.update_appointment_type = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE appointmenttype SET title = ?, forTimeMin = ?, imageUrl = ?, openingTime = ?, closingTime = ?, updatedTimeStamp = ? WHERE id = ?",
      [
        params.title,
        params.forTimeMin,
        params.imageUrl,
        params.openingTime,
        params.closingTime,
        params.updatedTimeStamp,
        params.id,
      ],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`success`);
        else console.log(err);
        // console.log("The data from appointments table \n", rows);
      }
    );
  });
};
