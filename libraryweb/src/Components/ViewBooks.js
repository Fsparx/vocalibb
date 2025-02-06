import React from 'react'
import { useState,useEffect } from "react";
import axios from 'axios';
function ViewBooks() {
    const [books, setBooks] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    useEffect(() => {
      axios
        .get("http://localhost:5000/api/viewreserve") // Change this to match your backend API
        .then((response) => {
          setBooks(response.data); // Axios automatically parses JSON
          setLoading(false);
        })
        .catch((error) => {
          console.error("Error fetching users:", error);
          setLoading(false);
        });
    
    }, []);
    const handleCheckout = async (rid,bid,uid) => {
      if (!window.confirm("Are you sure you want to checkout this book?")) return;
  
      try {
        
        await axios.post(`http://localhost:5000/api/checkout/${rid}/${bid}/${uid}`);
        setBooks(books.filter(book => book.rid !== rid)); // Update state after deletion
      } catch (err) {
        console.error("Error deleting user:", err);
        setError("Error deleting user.");
      }
    };
  return (
    <div className="container mt-4">
      <h2 className="mb-4">Users List</h2>

      {loading ? (
        <p>Loading users...</p>
      ) : books.length === 0 ? (
        <p className="text-center">No users available.</p>
      ) : (
        <table className="table table-striped">
          <thead>
            <tr>
              <th>Reservation ID</th>
              <th>Reg no</th>
              <th>Title</th>
              <th>Author</th>
              <th>Reservation Time</th>
              <th>Checkout</th>
            </tr>
          </thead>
          <tbody>
            {books.map((book) => (
              <tr key={book.bid}>
                <td>{book.rid}</td>
                <td>{book.regno}</td>
                <td>{book.title}</td>
                <td>{book.author}</td>
                <td>{book.rdt}</td>
                
                <td><button onClick={() => handleCheckout(book.rid,book.bid,book.id)} className="btn btn-primary w-70 btn">Checkout</button></td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  )
}

export default ViewBooks