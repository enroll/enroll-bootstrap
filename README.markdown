# Boostrapping Enroll server

1. SSH to server, create user `enroll`, setup keys, add to sudoers with NOPASSWD option.
2. Disable root login, disable password authentication
3. `cp config/deploy.example.rb config/deploy.rb`
4. [Increase SWAP size](https://www.digitalocean.com/community/articles/how-to-add-swap-on-ubuntu-12-04) in case of 512MB droplet
5. Run `sprinkle -c -s config/install.rb`. Might take a while.