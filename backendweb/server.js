const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');
const app = express();

// Middleware
app.use(cors());
app.use(express.json());

// MySQL Database Connection
const db = mysql.createConnection({
  host: '127.0.0.1',
  user: 'root',
  password: '',
  database: 'librarynew', // Replace with your database name
});

db.connect((err) => {
  if (err) {
    console.error('Error connecting to the database:', err.stack);
  } else {
    console.log('Connected to the MySQL database');
  }
});

// Login Endpoint
app.post('/api/login', (req, res) => {
  const { username, password } = req.body;
    console.log(username,password,req.body)
  // Query to validate user
  const query = 'SELECT * FROM adminusers WHERE username = ? AND password = ?';

  db.query(query, [username, password], (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Database error', error: err });
    } else if (results.length > 0) {
      // User found
      res.json({ success: true, message: 'Login successful' });
    } else {
      // User not found
      res.status(401).json({ success: false, message: 'Invalid username or password' });
    }
  });
});
app.post('/api/adduser', (req, res) => {
  const { regno, firstname,lastname,password } = req.body.formData;
    //console.log(req.body)
  // Query to validate user
  const query = 'INSERT INTO users (regno,firstname,lastname,password) VALUES(?,?,?,?)';

  db.query(query, [regno,firstname,lastname,password], (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Database error', error: err });
    } else if (results.length > 0) {
      // User found
      res.json({ success: true, message: 'Login successful' });
    } else {
      // User not found
      res.status(401).json({ success: false, message: 'Invalid username or password' });
    }
  });
});
app.get('/api/viewuser', (req, res) => {
  const query = 'SELECT * FROM users';
  //console.log("hiii");
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Database error', error: err });
    }
    //console.log(results);
    res.json(results);
  });
});

app.delete('/api/users/:id', (req, res) => {
  const userId = req.params.id;
  const query = 'DELETE FROM users WHERE id = ?';

  db.query(query, [userId], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Database error', error: err });
    }
    res.json({ success: true, message: 'User deleted successfully' });
  });
});
app.post('/api/addbook', (req, res) => {
  const { title, author,year,pubdetails,category,isbn,rackid } = req.body.formData;
  console.log(req.body)
  // Query to validate user
  const query = 'INSERT INTO bookinfo (title,author,year,pubdetails,category,isbn,rackid) VALUES(?,?,?,?,?,?,?)';

  db.query(query, [title,author,year,pubdetails,category,isbn,rackid], (err, results) => {
    if (err) {
      res.status(500).json({ message: 'Database error', error: err });
    } else if (results.length > 0) {
      // User found
      res.json({ success: true, message: 'Book Added Succesfully' });
    } else {
      // User not found
      res.status(401).json({ success: false, message: 'Error' });
    }
  });
});
app.get('/api/viewreserve', (req, res) => {
  const query = 'SELECT * FROM reservation INNER JOIN bookinfo ON reservation.bid=bookinfo.bid INNER JOIN users ON users.id=reservation.uid';
  console.log("hiii");
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Database error', error: err });
    }
    console.log(results);
    res.json(results);
  });
});
app.post('/api/checkout/:rid/:bid/:uid', (req, res) => {
  const { rid, bid,uid } = req.params;
  const checkout_date = new Date();
    const expiry_date = new Date();
    expiry_date.setDate(checkout_date.getDate() + 7);
  const query = 'INSERT INTO checkout (rid,bid,cdt,edt,uid) VALUES(?,?,?,?,?)';

  db.query(query, [rid,bid,checkout_date,expiry_date,uid], (err, result) => {
    if (err) {
      return res.status(500).json({ message: 'Database error', error: err });
    }
    res.json({ success: true, message: 'Inserted into checkout table' });
  });
});
app.get('/api/viewcheckout', (req, res) => {
  const query = 'SELECT * FROM checkout INNER JOIN bookinfo ON checkout.bid=bookinfo.bid INNER JOIN users ON users.id=checkout.uid';
  console.log("hiii");
  db.query(query, (err, results) => {
    if (err) {
      return res.status(500).json({ message: 'Database error', error: err });
    }
    console.log(results);
    res.json(results);
  });
});
app.post('/api/checkin/:cid/:bid', (req, res) => {
  const { cid, bid } = req.params;
// 1. Get expiry date
console.log("edo");
  const sqlGetExpiry = `SELECT edt FROM checkout WHERE cid = ? AND bid = ?`;
  db.query(sqlGetExpiry, [cid, bid], (err, result) => {
      if (err) {
          console.error('Database Error:', err);
          return res.status(500).json({ error: 'Database error' });
      }

      if (result.length === 0) {
          return res.status(404).json({ error: 'No active checkout record found for this book.' });
      }

      const expiry_date = new Date(result[0].expiry_date);
      const today = new Date();
      let fineAmount = 0;

      if (today > expiry_date) {
          fineAmount = calculateFine(expiry_date, today);
      }

      // 2. Remove checkout record
      const sqlDeleteCheckout = `DELETE FROM checkout WHERE cid = ? AND bid = ?`;
      db.query(sqlDeleteCheckout, [cid, bid], (err, result) => {
          if (err) {
              console.error('Database Error:', err);
              return res.status(500).json({ error: 'Error removing checkout record' });
          }
          console.log("Removed checkout");
          // 3. Update book availability
          const sqlUpdateBook = `UPDATE bookinfo SET available = 'YES' WHERE bid = ?`;
          db.query(sqlUpdateBook, [bid], (err, result) => {
              if (err) {
                  console.error('Database Error:', err);
                  return res.status(500).json({ error: 'Error updating book availability' });
              }
              console.log("Available YES");
              res.json({
                  message: 'Check-in successful!',
                  fine: fineAmount > 0 ? `You have a fine of ₹${fineAmount}. Please pay before borrowing more books.` : 'No fine required.',
              });
          });
      });
  });
});


function calculateFine(expiry_date, today) {
  const daysLate = Math.ceil((today - expiry_date) / (1000 * 60 * 60 * 24)); // Convert ms to days
  return daysLate * 10;
}
// Start Server
const port = 5000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

