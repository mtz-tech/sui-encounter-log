# sui-encounter-log

A Move smart contract for logging encounters between Sui addresses, built for the Sui blockchain.

## 📦 Project Overview

This package defines a Move module `encounter_log` that allows users to:

- Log a single encounter with a recipient address and timestamp
- Log multiple encounters at once
- Burn expired encounters
- Retrieve sender, receiver, and timestamp info from an `Encounter` object

This project was originally tested on a local Sui devnet and is now being prepared for deployment on testnet.

## 📁 Project Structure

```
sui_encounter_log/
├── Move.toml                  # Package manifest
├── sources/                   # Move source files (encounter_log.move)
├── tests/                     # Move unit/integration tests (if any)
└── test_encounters.sh         # Bash script for CLI testing (local devnet)
```

## 🚀 Deployment

### ✅ Local Devnet (for testing)

Start local Sui devnet (inside container or host):

```bash
sui start
```

Publish the module:

```bash
sui client publish --gas-budget 100000000
```

### 🌐 Testnet (real network)

> You must **remove or comment** the `published-at` field and set address to `0x0` before publishing:
>
> ```toml
> # published-at = "0x..."
> [addresses]
> sui_encounter_log = "0x0"
> ```

Then:

```bash
sui client publish --gas-budget 100000000 --network testnet
```

Update `published-at` and `addresses` in `Move.toml` after deployment with the new on-chain address.

## 🔬 Example Usage

From CLI (example):

```bash
sui client call \
  --package <PACKAGE_ID> \
  --module encounter_log \
  --function log_encounter \
  --args <recipient_address> <timestamp> \
  --gas-budget 100000000
```

Use the included `test_encounters.sh` script to automate testing.

## 🧠 Author

Martin Martinez  
GitHub: [@mtz-tech](https://github.com/mtz-tech)

---

This repo is part of a larger research initiative into privacy-preserving Sybil defense using Sui and Move.