import LoginPage from "./Components/LoginPage";
import './App.css';
import { BrowserRouter as Router, Route, Routes, useNavigate } from 'react-router-dom';
import HomePage from "./Components/HomePage";
import AddUsers from "./Components/AddUsers";
import ViewUsers from "./Components/ViewUsers";
import Addbook from "./Components/Addbook";
import ViewBooks from "./Components/ViewBooks";

function App() {
  return (
    <div className="App">
      <Router>
      <Routes>
        <Route path="/" element={<LoginPage />} />
        <Route path="/home" element={<HomePage/>}/>
        <Route path="/admin/adduser" element={<AddUsers/>}/>
        <Route path="/admin/viewuser" element={<ViewUsers/>}/>
        <Route path="/admin/addbook" element={<Addbook/>}/>
        <Route path="/admin/viewbook" element={<ViewBooks/>}/>
      </Routes>
    </Router>
    </div>
  );
}

export default App;
