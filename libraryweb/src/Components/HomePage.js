import React from 'react'
import { Link } from "react-router-dom";
import "bootstrap/dist/css/bootstrap.min.css";
function HomePage() {
  return (
    <div className="container mt-5">
      <div className="text-center mb-4">
        <h1 className="display-4">Welcome to the Admin Panel</h1>
        <p className="lead">Manage the system effectively using the options below.</p>
      </div>
      <div className="row">
        <div className="col-md-6 mb-4">
          <Link to="/admin/adduser" className="card shadow-sm text-decoration-none">
            <div className="card-body text-center">
              <h5 className="card-title">Add Stuent</h5>
              <p className="card-text">Add Users</p>
            </div>
          </Link>
        </div>
        <div className="col-md-6 mb-4">
          <Link to="/admin/viewuser" className="card shadow-sm text-decoration-none">
            <div className="card-body text-center">
              <h5 className="card-title">View Users</h5>
              <p className="card-text">List the student info.</p>
            </div>
          </Link>
        </div>
        <div className="col-md-6 mb-4">
          <Link to="/admin/addbook" className="card shadow-sm text-decoration-none">
            <div className="card-body text-center">
              <h5 className="card-title">Add books</h5>
              <p className="card-text">Add book information</p>
            </div>
          </Link>
        </div>
        <div className="col-md-6 mb-4">
          <Link to="/admin/viewbook" className="card shadow-sm text-decoration-none">
            <div className="card-body text-center">
              <h5 className="card-title">Reservations</h5>
              <p className="card-text">View Reservations</p>
            </div>
          </Link>
        </div>
      </div>
      <div className="text-center mt-4">
        <p className="text-muted"></p>
      </div>
    </div>
  )
}

export default HomePage