const db = require("../db/db");

exports.get_analyses = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query("SELECT * FROM analyses", (err, rows) => {
      connection.release();
      if (!err) {
        res.send(rows);
      } else {
        console.log(err);
      }
      console.log("the data from analyses table are : \n", rows);
    });
  });
};

exports.get_analyses_byId = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query(
      "SELECT * FROM analyses WHERE category_id = ?",
      [req.params.id],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(rows);
        } else {
          console.log(err);
        }
        console.log("the data from analyses table are : \n", rows);
      }
    );
  });
};

exports.get_cat_analyse = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query("SELECT id, name, price FROM analyses", (err, rows) => {
      connection.release();
      if (!err) {
        res.send(rows);
      } else {
        console.log(err);
      }
      console.log("the data from analyses table are : \n", rows);
    });
  });
};

exports.get_categories = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query("SELECT * FROM categories", (err, rows) => {
      connection.release();
      if (!err) {
        res.send(rows);
      } else {
        console.log(err);
      }
      console.log("the data from categories table are : \n", rows);
    });
  });
};
