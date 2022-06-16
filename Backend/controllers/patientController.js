const db = require("../db/db");

exports.add_user = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;

    connection.query(
      "INSERT INTO patient WHERE uId = ?",
      params,
      (err, rows) => {
        connection.release();
        if (!err) res.send(`Bien Enregistrer!! ID : ${params.uId} bien`);
        else console.log(err);

        console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.update_user = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE patient SET firstName = ?, lastName = ?, city = ?, email = ?, age = ?, uId = ?, gender = ?, pNo = ?, familySituation = ?, hasCnss = ?, hasRamid = ?, cin = ?, bloodType = ? WHERE uId = ?",
      [
        params.firstName,
        params.lastName,
        params.city,
        params.email,
        params.age,
        params.uId,
        params.gender,
        params.pNo,
        params.familySituation,
        params.hasCnss,
        params.hasRamid,
        params.cin,
        params.bloodType,
        params.uId,
      ],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`Bien Enregistrer!! ID : ${params.uId} bien`);
        else console.log(err);

        console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.update_user_fcm = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    const params = req.body;
    connection.query(
      "UPDATE patient SET fcmId = ? WHERE uId = ?",
      [params.fcmId, params.uId],
      (err, rows) => {
        connection.release();
        if (!err) res.send(`Bien Enregistrer!! ID : ${params.uId} bien`);
        else console.log(err);

        console.log("The data from user table \n", rows);
      }
    );
  });
};

exports.get_user = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query(
      "SELECT * FROM patient WHERE uId = ?",
      [req.params.uId],
      (err, rows) => {
        connection.release();
        if (!err) res.send(rows);
        else console.log(err);

        console.log("The data from user table \n", rows);
      }
    );
  });
};
