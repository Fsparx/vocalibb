import React from 'react'
import { useState,useEffect } from "react";
import axios from 'axios';
function Addbook() {
    const [error, setError] = useState('');
    const [formData, setFormData] = useState({
        title: "",
        author: "",
        year: "",
        pubdetails: "",
        category:"",
        isbn:"",
        rackid:"",
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
          const response = await axios.post('http://localhost:5000/api/addbook', {
           formData
          });
    
          if (response.data.success) {
            // Redirect to dashboard if login is successful
            alert("Book Added Successfully");
            
            
          }
        } catch (err) {
          // Handle error (e.g., invalid credentials)
          setError(err.response?.data?.message || 'Login failed');
        }
      };
  return (
    <div className="container mt-4">
    <h2 className="mb-4">Add New Book</h2>
    <form onSubmit={handleSubmit}>
      <div className="mb-3">
        <label className="form-label">Title</label>
        <input type="text" className="form-control" name="title" value={formData.title} onChange={handleChange} required />
      </div>
      <div className="mb-3">
        <label className="form-label">Author</label>
        <input type="text" className="form-control" name="author" value={formData.author} onChange={handleChange} required />
      </div>
      <div className="mb-3">
        <label className="form-label">Year</label>
        <input type="text" className="form-control" name="year" value={formData.year} onChange={handleChange} required/>
      </div>
      <div className="mb-3">
        <label className="form-label">Publication details</label>
        <input type="text" className="form-control" name="pubdetails" value={formData.pubdetails} onChange={handleChange} required/>
      </div>
      <div className="mb-3">
        <label className="form-label">Category</label>
        <select name="category" value={formData.category} onChange={handleChange} className="form-select">
            <option value="">-- Select --</option>
            <option value="ART">ARTS-SPORTS</option>
            <option value="AST">ASTRONOMY</option>
            <option value="BOT">BOTANY</option>
            <option value="CHEM">CHEMISTRY</option>
            <option value="COMP">COMPUTER SCIENCE</option>
            <option value="ECON">ECONOMICS</option>
            <option value="EDU">EDUCATION</option>
            <option value="ENCY">ENCYCLOPEDIA- DICTIONARY</option>
            <option value="FIC">FICTION</option>
            <option value="GEN">GENERAL BOOKS-CAREER BOOKS</option>
            <option value="HIST">HISTORY-GEOGRAPHY -BIOGRAPHY</option>
            <option value="INDIA">SOUTH ASIA</option>
            <option value="LANG">LANG</option>
            <option value="LAW">LAW</option>
            <option value="LIF">LIFE SCIENCE</option>
            <option value="LIT">LITERATURE</option>
            <option value="MANG">MANAGEMENT</option>
            <option value="MATH">MATHEMATICS</option>
            <option value="MED">MEDICINE & HEALTH</option>
            <option value="NFIC">NON-FICTION</option>
            <option value="PHIL">PHILOSOPHY</option>
            <option value="PHYS">PHYSICS</option>
            <option value="PSYC">PSYCHOLOGY</option>
            <option value="PUBL">PUBLIC ADMINISTRATION</option>
            <option value="REF">REFERENCE</option>
          </select>
      </div>
      <div className="mb-3">
        <label className="form-label">ISBN</label>
        <input type="text" className="form-control" name="isbn" value={formData.isbn} onChange={handleChange} required/>
      </div>
      <div className="mb-3">
        <label className="form-label">Rack ID</label>
        <input type="text" className="form-control" name="rackid" value={formData.rackid} onChange={handleChange} required/>
      </div>
      <button type="submit" className="btn btn-primary">Add User</button>
    </form>
  </div>
  )
}

export default Addbook