import React, { useState, useEffect } from "react";
import axios from "axios";

function ViewUsers() {
  const [users, setUsers] = useState([]);

  useEffect(() => {
    const fetchUsers = async () => {
      try {
        const { data } = await axios.get("http://localhost:5000/api/viewuser");
        setUsers(data);
      } catch (error) {
        console.error("Error fetching users:", error);
      }
    };
    fetchUsers();
  }, []);

  const handleDelete = async (id) => {
    if (!window.confirm("Are you sure you want to delete this user?")) return;
    try {
      await axios.delete(`http://localhost:5000/api/users/${id}`);
      setUsers(users.filter((user) => user.id !== id));
    } catch (error) {
      console.error("Error deleting user:", error);
    }
  };

  return (
    <div className="container mt-4">
      <h2 className="mb-4 text-center">Users List</h2>
      {users.length === 0 ? (
        <p className="text-center text-muted">No users available.</p>
      ) : (
        <table className="table table-bordered text-center">
          <thead className="table-light">
            <tr>
              <th>Regno</th>
              <th>Firstname</th>
              <th>Lastname</th>
              <th>Action</th>
            </tr>
          </thead>
          <tbody>
            {users.map((user) => (
              <tr key={user.id}>
                <td>{user.regno}</td>
                <td>{user.firstname}</td>
                <td>{user.lastname}</td>
                <td>
                  <button onClick={() => handleDelete(user.id)} className="btn btn-danger btn-sm">
                    Delete
                  </button>
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      )}
    </div>
  );
}

export default ViewUsers;
