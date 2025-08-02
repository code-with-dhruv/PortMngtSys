-- Create table for the settlement account
CREATE TABLE settlement_account (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    balance DECIMAL(15,2) DEFAULT 0.00,
    currency VARCHAR(10) DEFAULT 'USD',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Create table for transactions
CREATE TABLE transactions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('BUY', 'SELL') NOT NULL,
    ticker VARCHAR(10) NOT NULL,
    amount INT NOT NULL,
    price DECIMAL(15,2) NOT NULL,
    total_amount DECIMAL(15,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
-- Insert random values into settlement_account table
INSERT INTO settlement_account (user_id, balance, currency)
VALUES
  (1, ROUND(RAND() * 10000, 2), 'USD'),
  (2, ROUND(RAND() * 5000, 2), 'USD'),
  (3, ROUND(RAND() * 15000, 2), 'USD'),
  (4, ROUND(RAND() * 12000, 2), 'USD'),
  (5, ROUND(RAND() * 2000, 2), 'USD'),
  (6, ROUND(RAND() * 8000, 2), 'USD'),
  (7, ROUND(RAND() * 1000, 2), 'USD'),
  (8, ROUND(RAND() * 2500, 2), 'USD'),
  (9, ROUND(RAND() * 11000, 2), 'USD'),
  (10, ROUND(RAND() * 7000, 2), 'USD');
-- Insert random transactions (buy and sell) for users
INSERT INTO transactions (user_id, type, ticker, amount, price, total_amount)
VALUES
  (1, 'BUY', 'AAPL', 10, ROUND(RAND() * 150 + 100, 2), ROUND(10 * (RAND() * 150 + 100), 2)),
  (1, 'SELL', 'TSLA', 5, ROUND(RAND() * 700 + 500, 2), ROUND(5 * (RAND() * 700 + 500), 2)),
  (2, 'BUY', 'GOOGL', 8, ROUND(RAND() * 1000 + 1200, 2), ROUND(8 * (RAND() * 1000 + 1200), 2)),
  (2, 'SELL', 'AMZN', 12, ROUND(RAND() * 3000 + 2000, 2), ROUND(12 * (RAND() * 3000 + 2000), 2)),
  (3, 'BUY', 'NFLX', 15, ROUND(RAND() * 600 + 400, 2), ROUND(15 * (RAND() * 600 + 400), 2)),
  (3, 'SELL', 'MSFT', 7, ROUND(RAND() * 250 + 150, 2), ROUND(7 * (RAND() * 250 + 150), 2)),
  (4, 'BUY', 'TSLA', 20, ROUND(RAND() * 1000 + 600, 2), ROUND(20 * (RAND() * 1000 + 600), 2)),
  (4, 'SELL', 'AAPL', 10, ROUND(RAND() * 150 + 100, 2), ROUND(10 * (RAND() * 150 + 100), 2)),
  (5, 'BUY', 'AMZN', 5, ROUND(RAND() * 3500 + 1500, 2), ROUND(5 * (RAND() * 3500 + 1500), 2)),
  (5, 'SELL', 'GOOGL', 8, ROUND(RAND() * 1000 + 1200, 2), ROUND(8 * (RAND() * 1000 + 1200), 2)),
  (6, 'BUY', 'GOOGL', 25, ROUND(RAND() * 1000 + 1200, 2), ROUND(25 * (RAND() * 1000 + 1200), 2)),
  (7, 'SELL', 'TSLA', 12, ROUND(RAND() * 700 + 500, 2), ROUND(12 * (RAND() * 700 + 500), 2)),
  (8, 'BUY', 'MSFT', 18, ROUND(RAND() * 250 + 150, 2), ROUND(18 * (RAND() * 250 + 150), 2)),
  (9, 'SELL', 'NFLX', 10, ROUND(RAND() * 600 + 400, 2), ROUND(10 * (RAND() * 600 + 400), 2)),
  (10, 'BUY', 'AAPL', 10, ROUND(RAND() * 150 + 100, 2), ROUND(10 * (RAND() * 150 + 100), 2));
