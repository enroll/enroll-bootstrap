# Boostrapping Enroll server

1. SSH to server, create user `enroll`, setup keys, add to sudoers with NOPASSWD option.
2. Fix locales:

        sudo locale-gen en_US.UTF-8
        sudo dpkg-reconfigure locales

3. Disable root login, disable password authentication
4. `cp config/deploy.example.rb config/deploy.rb`
5. [Increase SWAP size](https://www.digitalocean.com/community/articles/how-to-add-swap-on-ubuntu-12-04) in case of 512MB droplet
6. Run `sprinkle -c -s config/install.rb`. Might take a while.