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
      // console.log("the data from analyses table are : \n", rows);
    });
  });
};

exports.get_analyses_byId = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query(
      "SELECT * FROM analyses WHERE categoryId = ?",
      [req.params.id],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(rows);
        } else {
          console.log(err);
        }
        // console.log("the data from analyses table are : \n", rows);
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
      // console.log("the data from analyses table are : \n", rows);
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
      // console.log("the data from categories table are : \n", rows);
    });
  });
};

exports.get_categories_by_id = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query(
      "SELECT name ,id FROM categories WHERE id = ?",
      [req.params.id],
      (err, rows) => {
        connection.release();
        if (!err) {
          res.send(rows);
        } else {
          console.log(err);
        }
        // console.log("the data from categories table are : \n", rows);
      }
    );
  });
};

exports.update_categories = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE categories SET name = ?, description = ?, updatedTimeStamp = ? WHERE id = ?",
      [params.name, params.description, params.updatedTimeStamp, params.id],

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

exports.update_analyses = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE analyses SET name = ?, libBilan = ?, libAutomat = ?, valeurReference = ?, unite = ?, price = ?, description = ?, min = ?, max = ?, categoryId = ?, categoryName = ?, titre = ?, updatedTimeStamp = ?  WHERE id = ?",
      [
        params.name,
        params.libBilan,
        params.libAutomat,
        params.valeurReference,
        params.unite,
        params.price,
        params.description,
        params.min,
        params.max,
        params.categoryId,
        params.categoryName,
        params.titre,
        params.updatedTimeStamp,
        params.id,
      ],

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

exports.update_categories = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE categories SET name = ?, description = ?, updatedTimeStamp = ? WHERE id = ?",
      [params.name, params.description, params.updatedTimeStamp, params.id],

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

exports.delete_analyses = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "DELETE FROM analyses WHERE id = ?",
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

exports.delete_categories = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "DELETE FROM categories WHERE id = ?",
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

exports.add_analyses = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query("INSERT INTO analyses SET ?", params, (err, rows) => {
      connection.release();
      if (!err) res.send(`success`);
      else console.log(err);

      // console.log("The data from prescription table \n", rows);
    });
  });
};

exports.add_categories = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query("INSERT INTO categories SET ?", params, (err, rows) => {
      connection.release();
      if (!err) res.send(`success`);
      else console.log(err);

      // console.log("The data from prescription table \n", rows);
    });
  });
};
