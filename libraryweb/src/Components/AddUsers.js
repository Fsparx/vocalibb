import React from 'react'
import { useState } from "react";
import axios from 'axios';
function AddUsers() {
    const [error, setError] = useState('');
    const [formData, setFormData] = useState({
        regno: "",
        firstname: "",
        lastname: "",
        password: "",
        confirmpassword:"",
      });
    
      const handleChange = (e) => {
        setFormData({ ...formData, [e.target.name]: e.target.value });
      };
    
      const handleSubmit = async(e) => {
        e.preventDefault();
        console.log("Form submitted", formData);
        // Add API call logic here
        e.preventDefault();
        alert("handling");
        try {
          const response = await axios.post('http://localhost:5000/api/adduser', {
           formData
          });
    
          if (response.data.success) {
            // Redirect to dashboard if login is successful
            alert("User Added Successfully");
            
            
          }
        } catch (err) {
          // Handle error (e.g., invalid credentials)
          setError(err.response?.data?.message || 'Login failed');
        }
      };
  return (
    <div className="container mt-4">
      <h2 className="mb-4">Add New User</h2>
      <form onSubmit={handleSubmit}>
        <div className="mb-3">
          <label className="form-label">Regno</label>
          <input type="text" className="form-control" name="regno" value={formData.regno} onChange={handleChange} required />
        </div>
        <div className="mb-3">
          <label className="form-label">Firstname</label>
          <input type="text" className="form-control" name="firstname" value={formData.firstname} onChange={handleChange} required />
        </div>
        <div className="mb-3">
          <label className="form-label">Lastname</label>
          <input type="text" className="form-control" name="lastname" value={formData.lastname} onChange={handleChange} />
        </div>
        <div className="mb-3">
          <label className="form-label">Password</label>
          <input type="password" className="form-control" name="password" value={formData.password} onChange={handleChange} />
        </div>
        <div className="mb-3">
          <label className="form-label">Confirm Password</label>
          <input type="password" className="form-control" name="confirmpassword" value={formData.confirmpassword} onChange={handleChange} />
        </div>
        
        <button type="submit" className="btn btn-primary">Add User</button>
      </form>
    </div>
  )
}

export default AddUsers