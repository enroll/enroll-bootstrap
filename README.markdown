# Boostrapping Enroll server

1. SSH to server, create user `enroll`, setup keys, add to sudoers with NOPASSWD option.
2. Disable root login, disable password authentication
3. `cp config/deploy.example.rb config/deploy.rb`
4. Run `sprinkle -c -s config/install.rb`. Might take a while.