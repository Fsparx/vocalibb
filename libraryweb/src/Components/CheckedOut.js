import React, { useState, useEffect } from "react";
import axios from "axios";

function CheckedOut() {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios
      .get("http://localhost:5000/api/viewcheckout")
      .then(({ data }) => setBooks(data))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const handleCheckIn = async (cid, bid) => {
    if (!window.confirm("Are you sure you want to check in this book?")) return;

    try {
      const { data } = await axios.post(`http://localhost:5000/api/checkin/${cid}/${bid}`);
      alert(data.fine);
      setBooks((prev) => prev.filter((book) => book.cid !== cid));
    } catch (err) {
      console.error("Error checking in book:", err);
    }
  };

  return (
    <div className="container mt-4">
      <h2 className="mb-4 text-center">Checked-Out Books</h2>

      {loading ? (
        <p className="text-center">Loading...</p>
      ) : books.length === 0 ? (
        <p className="text-center">No books to be returned.</p>
      ) : (
        <table className="table table-striped text-center">
          <thead>
            <tr>
              {["Checkout ID", "Book ID", "Reg No", "Title", "Expiry Time", "Action"].map((head) => (
                <th key={head}>{head}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {books.map(({ cid, bid, regno, title, edt }) => (
              <tr key={cid}>
                <td>{cid}</td>
                <td>{bid}</td>
                <td>{regno}</td>
                <td>{title}</td>
                <td>{edt}</td>
                <td>
                  <button onClick={() => handleCheckIn(cid, bid)} className="btn btn-success btn-sm">
                    Check-In
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

export default CheckedOut;
