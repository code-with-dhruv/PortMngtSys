import express from 'express';
import mysql from 'mysql2';
import bodyParser from 'body-parser';

const app = express();
app.use(bodyParser.json());

// MySQL connection setup
const pool = mysql.createPool({
  host: 'localhost',  // Change to your MySQL host
  user: 'root',       // MySQL username
  password: 'n3u3da!',       // MySQL password
  database: 'project', // Your MySQL database name
  waitForConnections: true,
  connectionLimit: 10,
  queueLimit: 0
});

// Helper function to query MySQL
function queryDatabase(query, params = []) {
  return new Promise((resolve, reject) => {
    pool.execute(query, params, (err, results) => {
      if (err) reject(err);
      else resolve(results);
    });
  });
}

// API to fetch settlement account balance for a user
app.get('/settlement-account/:userId', async (req, res) => {
  const { userId } = req.params;
  try {
    const result = await queryDatabase('SELECT * FROM settlement_account WHERE user_id = ?', [userId]);
    if (result.length === 0) {
      return res.status(404).json({ message: 'Settlement account not found' });
    }
    res.json(result[0]);
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// API to buy stock (update settlement account)
app.post('/buy', async (req, res) => {
  const { userId, ticker, amount, price } = req.body;

  try {
    // Calculate total cost
    const totalCost = amount * price;

    // Get the user's settlement account
    const [settlementAccount] = await queryDatabase('SELECT * FROM settlement_account WHERE user_id = ?', [userId]);

    if (!settlementAccount) {
      return res.status(404).json({ message: 'Settlement account not found' });
    }

    if (settlementAccount.balance < totalCost) {
      return res.status(400).json({ message: 'Insufficient funds in the settlement account' });
    }

    // Deduct the total cost from the settlement account balance
    await queryDatabase('UPDATE settlement_account SET balance = balance - ? WHERE user_id = ?', [totalCost, userId]);

    // Create a new transaction record for the buy
    await queryDatabase('INSERT INTO transactions (user_id, type, ticker, amount, price, total_amount) VALUES (?, ?, ?, ?, ?, ?)', 
                        [userId, 'BUY', ticker, amount, price, totalCost]);

    res.json({ message: 'Stock purchased successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// API to sell stock (update settlement account)
app.post('/sell', async (req, res) => {
  const { userId, ticker, amount, price } = req.body;

  try {
    // Calculate total proceeds
    const totalProceeds = amount * price;

    // Get the user's settlement account
    const [settlementAccount] = await queryDatabase('SELECT * FROM settlement_account WHERE user_id = ?', [userId]);

    if (!settlementAccount) {
      return res.status(404).json({ message: 'Settlement account not found' });
    }

    // Add the total proceeds to the settlement account balance
    await queryDatabase('UPDATE settlement_account SET balance = balance + ? WHERE user_id = ?', [totalProceeds, userId]);

    // Create a new transaction record for the sell
    await queryDatabase('INSERT INTO transactions (user_id, type, ticker, amount, price, total_amount) VALUES (?, ?, ?, ?, ?, ?)', 
                        [userId, 'SELL', ticker, amount, price, totalProceeds]);

    res.json({ message: 'Stock sold successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// API to get the user's full portfolio (balance + transactions)
app.get('/portfolio/:userId', async (req, res) => {
  const { userId } = req.params;

  try {
    // Get the user's settlement account and transactions
    const settlementAccount = await queryDatabase('SELECT * FROM settlement_account WHERE user_id = ?', [userId]);
    //const transactions = await queryDatabase('SELECT * FROM transactions WHERE user_id = ?', [userId]);

    if (settlementAccount.length === 0) {
      return res.status(404).json({ message: 'Settlement account not found' });
    }

    res.json({
      settlementAccount: settlementAccount[0],
      //transactions
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'Server error' });
  }
});

// Start the server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server running on port ${PORT}`);
});
