import React,{ useState } from 'react'
import '../Styles/LoginPage.css'
import { useNavigate } from 'react-router-dom';
import axios from 'axios';

function LoginPage() {
const [username, setUsername] = useState('');
  const [password, setPassword] = useState('');
  const [error, setError] = useState('');
  const navigate = useNavigate();
 
    
    const handleLogin = async (e) => {
        e.preventDefault();
        alert("handling");
        try {
          const response = await axios.post('http://localhost:5000/api/login', {
            username,
            password,
          });
    
          if (response.data.success) {
            // Redirect to dashboard if login is successful
            alert("Login succesfull");
            navigate('/home');
            
          }
        } catch (err) {
          // Handle error (e.g., invalid credentials)
          setError(err.response?.data?.message || 'Login failed');
        }
      };
  
  return (
    
    <div className="login-container">
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"></link>
        <h2 className="login-header">Welcome to Francis Sales Library</h2>
        <h2 className="login-header">Admin Login</h2>
        <form onSubmit={handleLogin}>
            

            <div className="mb-3">
                <label for="email" className="form-label">Username</label>
                <input type="text" className="form-control" id="email" name="email" onChange={(e) => setUsername(e.target.value)} required/>
            </div>
            <div className="mb-3">
                <label for="password" className="form-label">Password</label>
                <input type="password" className="form-control" id="password" name="password" onChange={(e) => setPassword(e.target.value)} required/>
            </div>
           
            <button type="submit" className="btn btn-primary w-70 btn">Login</button>
        </form>

        <div className="text-center mt-3">
            <small></small>
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </div>
    </div>
  )
}

export default LoginPage