const express = require ('express');
const bodyParser = require ('body-parser');
const mysql = require ('mysql');

const app = express();
const port = process.env.PORT || 5000;

app.use(express.urlencoded({extended: true}));

app.use(express.json());

const pool = mysql.createPool({
    connectionLimit : 10,
    host            : 'localhost',
    user            : 'root',
    password        : '',
    database        : 'syslab'
});

app.get('/get_availability', (req, res) => {
    pool.getConnection((err, connection) => {
        if (err) throw err;
        console.log('connection as id ' + connection.threadId)
        connection.query('SELECT * FROM availability', (err, rows) => {
            connection.release()
            if(!err){
                res.send(rows)
            } else {
                console.log(err)
            }

            console.log("the data from availability table are : \n", rows);
        });
    })
});



app.listen(port, () => console.log(`Listening on port ${port}`));