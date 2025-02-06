import React from 'react'
import { useState,useEffect } from "react";
import axios from 'axios';
function ViewBooks() {
    const [books, setBooks] = useState([]);
    const [loading, setLoading] = useState(true);
    const [error, setError] = useState("");
    useEffect(() => {
      axios
        .get("http://localhost:5000/api/viewbook") // Change this to match your backend API
        .then((response) => {
          setBooks(response.data); // Axios automatically parses JSON
          setLoading(false);
        })
        .catch((error) => {
          console.error("Error fetching users:", error);
          setLoading(false);
        });
    
    }, []);
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
              <th>Regno</th>
              <th>Firstname</th>
              <th>Lastname</th>
              <th>Delete</th>
            </tr>
          </thead>
          <tbody>
            {books.map((book) => (
              <tr key={book.bid}>
                <td>{book.regno}</td>
                <td>{book.firstname}</td>
                <td>{book.lastname}</td>
                <td><button  className="btn btn-primary w-70 btn">Delete</button></td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  )
}

export default ViewBooks