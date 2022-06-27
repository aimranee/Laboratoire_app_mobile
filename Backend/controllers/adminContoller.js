const db = require("../db/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

exports.login = function (req, res) {
  try {
    const params = req.body;
    db.query(
      `SELECT * FROM admin WHERE email = ?`,
      [params.email],
      (err, results) => {
        if (err) {
          console.log(err);
        }
        if (!results) {
          return res.json({
            success: 0,
            data: "Invalid email or password",
          });
        }

        // return res.send("hereee : " + results[0].password);

        const result = bcrypt.compareSync(params.password, results[0].password);
        if (result) {
          results[0].password = undefined;
          const jsontoken = jwt.sign({ result: results[0] }, "patientP2M", {
            expiresIn: "1h",
          });
          return res.json({
            success: 1,
            message: "login successfully",
            token: jsontoken,
            uId: results[0].uId,
          });
        } else {
          return res.json({
            success: 0,
            data: "Invalid email or password",
          });
        }
      }
    );
  } catch (e) {
    console.log("here");
    // console.log(error);
    return res.send("error in server");
  }
};

exports.signup = function (req, res) {
  db.getConnection((err, connection) => {
    try {
      if (err) throw new Error("database connexion error");
      const params = req.body;
      connection.query(
        `SELECT * FROM admin WHERE LOWER(email) = LOWER(?)`,
        params.email,
        (err, result) => {
          if (result.length) {
            // error
            return res.status(409).send({ message: "Email deja existe" });
          } else {
            const salt = bcrypt.genSaltSync(10);
            let hashedPassword = bcrypt.hashSync(params.password, salt);
            if (!hashedPassword) {
              // throw new Error("error in hash");
              return res.json(
                { success: false, message: "error in hash password" },
                500
              );
            } else {
              console.log(hashedPassword);
              connection.query(
                `INSERT INTO admin (firstName, lastName, aNo1, aNo2, email, password, subTitle, description, fcmId, whatsAppNo, address)values(?,?,?,?,${db.escape(
                  params.email
                )},'${hashedPassword}',?,?,?,?,?);`,
                [
                  params.firstName,
                  params.lastName,
                  params.aNo1,
                  params.aNo2,
                  params.subTitle,
                  params.description,
                  params.fcmId,
                  params.whatsAppNo,
                  params.address,
                ],
                (err, rows) => {
                  connection.release();
                  if (!err) {
                    db.query(
                      `SELECT * FROM admin WHERE email = ?`,
                      [params.email],
                      (err, results) => {
                        if (err) {
                          console.log(err);
                        }
                        if (!results) {
                          return res.json({
                            success: 0,
                            data: "Invalid email or password",
                          });
                        }
                        if (result) {
                          results[0].password = undefined;
                          const jsontoken = jwt.sign(
                            { result: results[0] },
                            "adminP2M",
                            {
                              expiresIn: "1h",
                            }
                          );
                          return res.json({
                            success: 1,
                            message: "Register successfully",
                            token: jsontoken,
                            uId: results[0].uId,
                          });
                        } else {
                          return res.json({
                            success: 0,
                            data: "Invalid email or password",
                          });
                        }
                      }
                    );
                  } else console.log(err);

                  console.log("The data from user table \n", rows);
                }
              );
            }
          }
        }
      );
    } catch (error) {
      console.log("here");
      // console.log(error);
      return res.send("error in server");
    }
  });
};

exports.update_user = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw new Error("database Error");
    const params = req.body;
    connection.query(
      "UPDATE admin SET firstName = ?, lastName = ?, city = ?, email = ?, age = ?, uId = ?, gender = ?, pNo = ?, familySituation = ?, hasCnss = ?, hasRamid = ?, cin = ?, bloodType = ? WHERE uId = ?",
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
        if (!err) res.send(`success`);
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
      "UPDATE admin SET fcmId = ? WHERE uId = ?",
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
      "SELECT * FROM admin WHERE uId = ?",
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

exports.get_all_user = function (req, res) {
  db.getConnection((err, connection) => {
    if (err) throw err;
    connection.query("SELECT * FROM patient", (err, rows) => {
      connection.release();
      if (!err) res.send(rows);
      else console.log(err);

      console.log("The data from user table \n", rows);
    });
  });
};
