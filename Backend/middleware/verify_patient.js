const jwt = require("jsonwebtoken");

module.exports = async (req, res, next) => {
  try {
    const token = req.headers.authorization.split(" ")[1];
    const decode = jwt.verify(tokren, "PATIENT");
    req.userData = decode;
    next();
  } catch (err) {
    return res.json({ message: "auth for patient is error" });
  }
};
