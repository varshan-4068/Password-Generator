## Password Generator

A **lightweight Bash password generator** with customizable character counts, shuffling, and clipboard support. Designed for Linux users, it integrates well with bash shell.

<img width="1920" height="1080" alt="screenshot-2025-12-23_13-33-14" src="https://github.com/user-attachments/assets/efb18fb8-2ee0-416d-8c80-baf783e84626" />

## Installation

1. Clone the repository:

        git clone https://github.com/<your-username>/Password-Generator.git
        cd Password-Generator

2. Make the script executable:

        chmod +x password.sh

3. Run the script:

        ./password.sh

## Features

- Generate **strong passwords** with:
  - Uppercase letters
  - Lowercase letters
  - Numbers
  - Special characters
- Optional recommended presets for:
  - Wi-Fi passwords
  - SSH keys
  - Admin accounts
- Passwords are **randomly shuffled** for maximum entropy.
- Passwords are **copied to the clipboard automatically** (`wl-copy` support).
- Tracks previously generated passwords using **SHA256 hashes** to warn about reuse.
- Fully **terminal-based** with colorful TUI prompts.
- Lightweight: runs with just Bash and standard Linux utilities such as tr,grep,wl-clipboard.
