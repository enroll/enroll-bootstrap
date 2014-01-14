# Boostrapping Enroll server

1. SSH to server, create user `enroll`:

        adduser enroll

2. Add `enroll` to `/etc/sudoers`, don't require password:

        enroll ALL=(ALL:ALL) NOPASSWD: ALL

3. Copy public keys for user enroll.

4. Fix locales:

        sudo locale-gen en_US.UTF-8
        sudo dpkg-reconfigure locales

5. Disable password authentication. Edit `/etc/ssh/sshd_config` to:

        ChallengeResponseAuthentication no
        PasswordAuthentication no
        UsePAM no

        # Then:
        sudo service ssh restart

6. [Increase SWAP size](https://www.digitalocean.com/community/articles/how-to-add-swap-on-ubuntu-12-04) in case of 512MB droplet

7. Run:

        ./bootstrap.sh staging staging.enroll.io
        ./bootstrap.sh production enroll.io