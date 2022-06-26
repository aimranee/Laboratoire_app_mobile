const db = require("../db/db");

exports.get_availability = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    console.log("connection as id " + connection.threadId);
    connection.query("SELECT * FROM availability", (err, rows) => {
      connection.release();
      if (!err) {
        res.send(rows);
      } else {
        console.log(err);
      }

      console.log("the data from availability table are : \n", rows);
    });
  });
};

exports.update_availability = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    console.log("connection as id " + connection.threadId);
    connection.query(
      "UPDATE availability SET mon = ?, tue = ?, wed = ?, thu = ?, fri = ?, sat = ?, sun = ?, updatedTimeStamp = '2022-06-12 21:26:18.000000' WHERE id = ?",
      [
        params.mon,
        params.tue,
        params.wed,
        params.thu,
        params.fri,
        params.sat,
        params.sun,
        params.id,
      ],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(`success`);
        } else {
          console.log(err);
        }

        console.log("the data from availability table are : \n", rows);
      }
    );
  });
};
