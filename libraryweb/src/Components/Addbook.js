import React, { useState } from "react";
import axios from "axios";

function AddBook() {
  const [formData, setFormData] = useState({
    title: "",
    author: "",
    year: "",
    pubdetails: "",
    category: "",
    isbn: "",
    rackid: "",
  });

  const handleChange = (e) => {
    setFormData({ ...formData, [e.target.name]: e.target.value });
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const { data } = await axios.post("http://localhost:5000/api/addbook", formData);
      if (data.success) alert("Book Added Successfully");
    } catch (error) {
      console.error("Error adding book:", error);
    }
  };

  return (
    <div className="container mt-4">
      <h2 className="mb-4 text-center">Add New Book</h2>
      <form onSubmit={handleSubmit} className="mx-auto" style={{ maxWidth: "500px" }}>
        {["title", "author", "year", "pubdetails", "isbn", "rackid"].map((field) => (
          <div key={field} className="mb-3">
            <label className="form-label">{field.toUpperCase()}</label>
            <input
              type="text"
              className="form-control"
              name={field}
              value={formData[field]}
              onChange={handleChange}
              required
            />
          </div>
        ))}

        <div className="mb-3">
          <label className="form-label">Category</label>
          <select name="category" value={formData.category} onChange={handleChange} className="form-select" required>
            <option value="">-- Select --</option>
            {[
              "ARTS-SPORTS",
              "ASTRONOMY",
              "BOTANY",
              "CHEMISTRY",
              "COMPUTER SCIENCE",
              "ECONOMICS",
              "EDUCATION",
              "ENCYCLOPEDIA-DICTIONARY",
              "FICTION",
              "GENERAL BOOKS-CAREER BOOKS",
              "HISTORY-GEOGRAPHY-BIOGRAPHY",
              "SOUTH ASIA",
              "LANG",
              "LAW",
              "LIFE SCIENCE",
              "LITERATURE",
              "MANAGEMENT",
              "MATHEMATICS",
              "MEDICINE & HEALTH",
              "NON-FICTION",
              "PHILOSOPHY",
              "PHYSICS",
              "PSYCHOLOGY",
              "PUBLIC ADMINISTRATION",
              "REFERENCE",
            ].map((cat) => (
              <option key={cat} value={cat}>
                {cat}
              </option>
            ))}
          </select>
        </div>

        <div className="text-center">
          <button type="submit" className="btn btn-success">Add Book</button>
        </div>
      </form>
    </div>
  );
}

export default AddBook;
