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
