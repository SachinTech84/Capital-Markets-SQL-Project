USE capital_markets

CREATE TABLE clients(
 client_id INT IDENTITY(1,1) PRIMARY KEY,
 client_name VARCHAR(100) NOT NULL,
 country VARCHAR(50),
 client_type VARCHAR(30)
)