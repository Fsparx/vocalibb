import React, { useState, useEffect } from "react";
import axios from "axios";

function ViewBooks() {
  const [books, setBooks] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios
      .get("http://localhost:5000/api/viewreserve")
      .then(({ data }) => setBooks(data))
      .catch(console.error)
      .finally(() => setLoading(false));
  }, []);

  const handleCheckout = async (rid, bid, uid) => {
    if (!window.confirm("Are you sure you want to checkout this book?")) return;

    try {
      await axios.post(`http://localhost:5000/api/checkout/${rid}/${bid}/${uid}`);
      setBooks((prev) => prev.filter((book) => book.rid !== rid));
    } catch (err) {
      console.error("Error checking out book:", err);
    }
  };

  return (
    <div className="container mt-4">
      <h2 className="mb-4 text-center">Reserved Books</h2>

      {loading ? (
        <p className="text-center">Loading...</p>
      ) : books.length === 0 ? (
        <p className="text-center">No books reserved.</p>
      ) : (
        <table className="table table-striped text-center">
          <thead>
            <tr>
              {["Reservation ID", "Reg No", "Title", "Author", "Reservation Time", "Action"].map((head) => (
                <th key={head}>{head}</th>
              ))}
            </tr>
          </thead>
          <tbody>
            {books.map(({ rid, regno, title, author, rdt, bid, id }) => (
              <tr key={rid}>
                <td>{rid}</td>
                <td>{regno}</td>
                <td>{title}</td>
                <td>{author}</td>
                <td>{rdt}</td>
                <td>
                  <button onClick={() => handleCheckout(rid, bid, id)} className="btn btn-danger btn-sm">
                    Checkout
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

export default ViewBooks;
