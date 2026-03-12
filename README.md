# Fabian Token — Bytecode Verification

Proof of source code for Fabian Token:

- [`0xe274d18ef7b194a1edebb04cfe297cfe1489ef65`](https://ethereumhistory.com/contracts/0xe274d18ef7b194a1edebb04cfe297cfe1489ef65) — deployed Oct 26 2015 (block 443,423)

Deployed by `0x9b22a80d5c7b3374a05b446081f97d0a34079e7f` (Fabian Vogelsteller).

## Contract

An early Ethereum token contract featuring a public `balanceof` mapping (lowercase) alongside an explicit `balanceOf(address)` function (camelCase). The constructor defaults to 10,000 supply if `0` is passed. Transfer events use LOG1 (non-indexed). This is a clean, minimal token implementation from October 2015 — before ERC-20 was formalized.

## Compiler

| Field | Value |
|---|---|
| **Image** | `soljson-v0.1.5+commit.23865e39` (JavaScript, via node.js) |
| **Optimization** | OFF |
| **Runtime size** | 625 bytes |

## Verification

Requires: node.js

```bash
./verify.sh
```

Expected: `⚠️  NEAR MATCH — 3 byte(s) differ (compiler layout ordering; all function bodies byte-identical)`

The script downloads `soljson-v0.1.5+commit.23865e39.js` from [binaries.soliditylang.org](https://binaries.soliditylang.org/bin/) if not already present.

### The 3-Byte Difference

The compiled output matches the on-chain bytecode at **622/625 bytes (99.5%)**. The 3 differing bytes are jump target addresses in the selector dispatch table — caused by a function body ordering difference in the compiler's internal representation. Both the `transfer` and `balanceOf` function bodies are **byte-identical** between compiled and on-chain.

This is a known artifact of early Solidity compilers (v0.1.x): the dispatch table's jump offsets shift when the compiler reorders function bodies internally. The source code, logic, and all opcodes match exactly.

## Key Insights

1. **Deployed by Fabian Vogelsteller** — creator of the ERC-20 standard; this contract predates ERC-20 by over a year
2. **Dual getter pattern** — `mapping (address => uint) public balanceof` auto-generates `balanceof(address)` (`0x3d64125b`); the explicit `balanceOf(address)` function (`0x70a08231`) uses camelCase. Both selectors are live on-chain
3. **Non-indexed Transfer event** — LOG1 (single topic = signature hash only); ERC-20 later mandated indexed `_from` and `_to` (LOG3)
4. **Constructor default** — `if (supply == 0) supply = 10000;` — passing `0` initializes with 10,000 tokens
5. **99.5% bytecode match** — the 3-byte difference is compiler dispatch ordering, not logic; all function bodies are byte-identical

## Selectors

- `3d64125b` → `balanceof(address)` — auto-getter from the public mapping (lowercase)
- `70a08231` → `balanceOf(address)` — explicit getter (camelCase)
- `a9059cbb` → `transfer(address,uint256)` — token transfer

## Files

- `MyToken.sol` — Solidity source
- `runtime.hex` — On-chain runtime bytecode (625 bytes, from Etherscan)
- `verify.sh` — Verification script (requires node.js)
