import React from 'react'
import { useState,useEffect } from "react";
import axios from 'axios';
function ViewUsers() {
    const [users, setUsers] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState("");
  useEffect(() => {
    axios
      .get("http://localhost:5000/api/viewuser") // Change this to match your backend API
      .then((response) => {
        setUsers(response.data); // Axios automatically parses JSON
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching users:", error);
        setLoading(false);
      });
  
  }, []);
  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this user?")) return;

    try {
      await axios.delete(`http://localhost:5000/api/users/${id}`);
      setUsers(users.filter(user => user.id !== id)); // Update state after deletion
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
      ) : users.length === 0 ? (
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
            {users.map((user) => (
              <tr key={user.id}>
                <td>{user.regno}</td>
                <td>{user.firstname}</td>
                <td>{user.lastname}</td>
                <td><button onClick={() => handleDelete(user.id)} className="btn btn-primary w-70 btn">Delete</button></td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  )
}

export default ViewUsers