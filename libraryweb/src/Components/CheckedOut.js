import React from 'react'
import { useState,useEffect } from "react";
import axios from 'axios';
function CheckedOut() {
    const [books, setBooks] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    useEffect(() => {
      axios
        .get("http://localhost:5000/api/viewcheckout") // Change this to match your backend API
        .then((response) => {
          setBooks(response.data); // Axios automatically parses JSON
          setLoading(false);
        })
        .catch((error) => {
          console.error("Error fetching users:", error);
          setLoading(false);
        });
    
    }, []);
    const handleCheckIn = async (cid,bid) => {
      if (!window.confirm("Are you sure you want to Check-In this book?")) return;
  
      try {
        await axios.post(`http://localhost:5000/api/checkin/${cid}/${bid}`).then(response => {
          console.log(response.data);
          alert(response.data.fine);
      })
      .catch(error => console.error('Error:', error));
        setBooks(books.filter(book => book.cid !== cid)); // Update state after deletion
      } catch (err) {
        console.error("Error deleting user:", err);
        setError("Error deleting user.");
      }
    };
  return (
    <div className="container mt-4">
    <h2 className="mb-4">Check In List</h2>

    {loading ? (
      <p>Loading ...</p>
    ) : books.length === 0 ? (
      <p className="text-center">No books to be returned.</p>
    ) : (
      <table className="table table-striped">
        <thead>
          <tr>
            <th>Checkout ID</th>
            <th>Book ID</th>
            <th>Regno</th>
            <th>Title</th>
            <th>Expiry Time</th>
            <th>Check-in</th>
          </tr>
        </thead>
        <tbody>
          {books.map((book) => (
            <tr key={book.cid}>
              <td>{book.cid}</td>
              <td>{book.bid}</td>
              <td>{book.regno}</td>
              <td>{book.title}</td>
              <td>{book.edt}</td>
              
              
              <td><button onClick={() => handleCheckIn(book.cid,book.bid)} className="btn btn-primary w-70 btn">Check-In</button></td>
            </tr>
          ))}
        </tbody>
      </table>
    )}
  </div>
  )
}

export default CheckedOut