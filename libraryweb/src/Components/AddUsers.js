import React, { useState } from "react";
import axios from "axios";
import "bootstrap/dist/css/bootstrap.min.css";

function AddUsers() {
  const [error, setError] = useState("");
  const [formData, setFormData] = useState({
    regno: "",
    firstname: "",
    lastname: "",
    password: "",
    confirmpassword: "",
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    if (formData.password !== formData.confirmpassword) {
      setError("Passwords do not match");
      return;
    }

    console.log("Form submitted", formData);

    try {
      const response = await axios.post("http://localhost:5000/api/adduser", formData);

      if (response.data.success) {
        alert("User Added Successfully");
        setFormData({ regno: "", firstname: "", lastname: "", password: "", confirmpassword: "" });
      }
    } catch (err) {
      setError(err.response?.data?.message || "Failed to add user");
    }
  };

  return (
    <div className="container mt-5">
      <div className="card shadow-sm border-0 p-4">
        <h2 className="mb-4 text-center text-dark">Add New User</h2>

        {error && <div className="alert alert-danger">{error}</div>}

        <form onSubmit={handleSubmit}>
          <div className="mb-3">
            <label className="form-label">Registration Number</label>
            <input type="text" className="form-control" name="regno" value={formData.regno} onChange={handleChange} required />
          </div>
          <div className="mb-3">
            <label className="form-label">First Name</label>
            <input type="text" className="form-control" name="firstname" value={formData.firstname} onChange={handleChange} required />
          </div>
          <div className="mb-3">
            <label className="form-label">Last Name</label>
            <input type="text" className="form-control" name="lastname" value={formData.lastname} onChange={handleChange} />
          </div>
          <div className="mb-3">
            <label className="form-label">Password</label>
            <input type="password" className="form-control" name="password" value={formData.password} onChange={handleChange} required />
          </div>
          <div className="mb-3">
            <label className="form-label">Confirm Password</label>
            <input type="password" className="form-control" name="confirmpassword" value={formData.confirmpassword} onChange={handleChange} required />
          </div>
          <div className="d-flex justify-content-center">
          <button type="submit" className="btn btn-success">Add User</button>
          </div>
          
        </form>
      </div>
    </div>
  );
}

export default AddUsers;
