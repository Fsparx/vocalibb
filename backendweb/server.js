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
// Start Server
const port = 5000;
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

