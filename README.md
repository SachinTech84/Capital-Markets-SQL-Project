# Capital Markets SQL Project

## Project Overview
 
This project simulates a simplified Capital Markets trading environment where clients execute trades through brokers across different securities.

The database is designed to support common trading and settlement activities, including:

- Client and broker management
- Securities and trade data
- Trade execution and status tracking
- Settlement processing
- Operational and management reporting
- Performance analysis

## Database Schema

The project uses the following core tables:

| Table | Purpose|
|---|---|
| `clients` | Stores client information |
| `Brokers` | Stores broker information |
| `Securities` | Stores security details |
| `Trades`| Stores trade execution records |
| `Settlements` | Stores settlement information |

## Key Relationships

- `Trades.ClientId` → `clients.client_id`
- `Trades.BrokerID` → `Brokers.BrokerID`
- `Trades.SecurityID` → `Securities.SecurityID`
- `Settlements.TradeId` → `Trades.TradeId`

The `Trades` table acts as the central transaction table connecting clients, brokers and securities.