#!/bin/bash

# Install rust and cargo using rustup
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install dotenv linter for use with null-ls
cargo install dotenv-linter
