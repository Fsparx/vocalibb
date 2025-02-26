import React from 'react';
import { Link } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";

function HomePage() {
  return (
    <div className="container mt-5">
      <div className="text-center mb-5">
        <h1 className="display-5 fw-semibold text-dark">Admin Panel</h1>
        <p className="text-muted">Manage the system efficiently using the options below.</p>
      </div>
      <div className="row justify-content-center">
        {[
          { path: "/admin/adduser", title: "Add Student", text: "Register a new student." },
          { path: "/admin/viewuser", title: "View Users", text: "Check student details." },
          { path: "/admin/addbook", title: "Add Books", text: "Enter new book details." },
          { path: "/admin/viewbook", title: "Reservations", text: "Manage book reservations." },
          { path: "/admin/checkin", title: "Check In", text: "Track checked-out books." },
        ].map((item, index) => (
          <div key={index} className="col-md-5 mb-4">
            <Link to={item.path} className="card shadow-sm border-0 text-decoration-none rounded-3">
              <div className="card-body text-center py-4">
                <h5 className="card-title text-dark fw-semibold">{item.title}</h5>
                <p className="card-text text-muted">{item.text}</p>
              </div>
            </Link>
          </div>
        ))}
      </div>
      <div className="text-center mt-4">
        <p className="text-muted">Admin Panel for Library Management</p>
      </div>
    </div>
  );
}

export default HomePage;
