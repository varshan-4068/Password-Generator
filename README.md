## Password Generator

A **lightweight Bash password generator** with customizable character counts, shuffling, and clipboard support. Designed for Linux users, it integrates well with bash shell.

<img width="1920" height="1080" alt="screenshot-2025-12-25_17-24-32" src="https://github.com/user-attachments/assets/e54745cb-0989-47ba-b634-8dee478f7b76" />

## Installation

1. Clone the repository:

       git clone https://github.com/varshan-4068/Password-Generator.git
       cd Password-Generator

3. Make the script executable:

       chmod +x password.sh

4. Run the script:

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
- Passwords are **randomly shuffled**.
- Passwords are **copied to the clipboard automatically** (`wl-copy` support).
- Tracks previously generated passwords using **SHA256 hashes** to warn about reuse.
- Fully **terminal-based** with colorful TUI prompts.
- Lightweight: runs with just Bash and standard Linux utilities such as tr,grep,wl-clipboard.
