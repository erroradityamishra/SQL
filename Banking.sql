-- Create the database
CREATE DATABASE BankManagement;

-- Use the database
USE BankManagement;

-- Create Customers table
CREATE TABLE Customers (
    CustomerID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Phone VARCHAR(15),
    Address VARCHAR(255)
);

-- Create Accounts table
CREATE TABLE Accounts (
    AccountID INT AUTO_INCREMENT PRIMARY KEY,
    CustomerID INT,
    AccountType ENUM('Savings', 'Checking') NOT NULL,
    Balance DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Create Transactions table
CREATE TABLE Transactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    AccountID INT,
    TransactionType ENUM('Deposit', 'Withdrawal') NOT NULL,
    Amount DECIMAL(10, 2) NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

-- Insert sample data into Customers
INSERT INTO Customers (FirstName, LastName, Email, Phone, Address) VALUES
('John', 'Doe', 'john.doe@example.com', '123-456-7890', '123 Elm St'),
('Jane', 'Smith', 'jane.smith@example.com', '098-765-4321', '456 Oak St');

-- Insert sample data into Accounts
INSERT INTO Accounts (CustomerID, AccountType, Balance) VALUES
(1, 'Savings', 1500.00),
(1, 'Checking', 200.00),
(2, 'Savings', 3000.00);

-- Insert sample data into Transactions
INSERT INTO Transactions (AccountID, TransactionType, Amount) VALUES
(1, 'Deposit', 500.00),
(1, 'Withdrawal', 200.00),
(2, 'Deposit', 1000.00),
(3, 'Withdrawal', 500.00);

-- Sample queries

-- Get all customers with their accounts
SELECT c.FirstName, c.LastName, a.AccountType, a.Balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID;

-- Get transaction history for a specific account
SELECT t.TransactionID, a.AccountType, t.TransactionType, t.Amount, t.TransactionDate
FROM Transactions t
JOIN Accounts a ON t.AccountID = a.AccountID
WHERE a.AccountID = 1;

-- Get total balance for each customer
SELECT c.FirstName, c.LastName, SUM(a.Balance) AS TotalBalance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
GROUP BY c.CustomerID;

-- Get all transactions of a specific type (e.g., Deposits)
SELECT t.TransactionID, c.FirstName, c.LastName, t.Amount, t.TransactionDate
FROM Transactions t
JOIN Accounts a ON t.AccountID = a.AccountID
JOIN Customers c ON a.CustomerID = c.CustomerID
WHERE t.TransactionType = 'Deposit';

-- Get customers with accounts having a balance below a threshold (e.g., 500)
SELECT c.FirstName, c.LastName, a.AccountType, a.Balance
FROM Customers c
JOIN Accounts a ON c.CustomerID = a.CustomerID
WHERE a.Balance < 500;
