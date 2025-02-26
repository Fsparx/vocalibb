import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css"; // Import Bootstrap once

function LoginPage() {
  const [credentials, setCredentials] = useState({ username: "", password: "" });
  const [error, setError] = useState("");
  const navigate = useNavigate();

  const handleChange = (e) => {
    setCredentials({ ...credentials, [e.target.name]: e.target.value });
  };

  const handleLogin = async (e) => {
    e.preventDefault();
    try {
      const { data } = await axios.post("http://localhost:5000/api/login", credentials);
      if (data.success) {
        alert("Login successful");
        navigate("/home");
      }
    } catch (err) {
      setError(err.response?.data?.message || "Login failed");
    }
  };

  return (
    <div className="login-container d-flex flex-column align-items-center justify-content-center vh-100">
      <h2 className="mb-3 text-center">Fr Francis Sales Library - Admin Login</h2>
      
      <form className="p-4 border rounded shadow-sm bg-light" onSubmit={handleLogin} style={{ width: "300px" }}>
        {error && <p className="alert alert-danger text-center">{error}</p>}

        <div className="mb-3">
          <label htmlFor="username" className="form-label">Username</label>
          <input type="text" name="username" className="form-control" onChange={handleChange} required />
        </div>

        <div className="mb-3">
          <label htmlFor="password" className="form-label">Password</label>
          <input type="password" name="password" className="form-control" onChange={handleChange} required />
        </div>

        <button type="submit" className="btn btn-success w-100">Login</button>
      </form>
    </div>
  );
}

export default LoginPage;
