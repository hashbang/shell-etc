# shell-etc #

<http://github.com/hashbang/shell-etc>

## About ##

This is the '/etc' directory of the #! shell servers.
Git management is handled via [etckeeper](http://etckeeper.branchable.com/)

New servers added to the pool will also have this configuration to give users an equal experience.

## Requirements ##

  * Debian 7+

## Contribution ##

Making changes to this repo will require a running #! [shell server](https://github.com/hashbang/shell-server).

An easy way to set this up locally is by running our latest shell-server 
[Docker image](https://hub.docker.com/r/hashbang/shell-server/).

A command like the following can get you going with a local development server:

```
docker run -d \
  -v /sys/fs/cgroup:/sys/fs/cgroup:ro \
  -v $PWD:/etc-git \
  -v $HOME/.gitconfig:/root/.gitconfig:ro \
  -v $HOME/.gnupg:/root/.gnupg \
  -v $SSH_AUTH_SOCK:/root/.ssh-agent \
  -e SSH_AUTH_SOCK=/root/.ssh-agent \
  --name shell-server \
  --cap-add SYS_ADMIN \
  hashbang/shell-server
```

From here you can enter this environment with:

```
docker exec -it shell-server bash
```

In this environment you can make updates and install packages with ```apt-get```.
Changes will automatically be committed and pushed to your working shell-etc
checkout by etckeeper. Assuming you chose to mount your .gitconfig above, the
changes should be attributed correctly as you, and signed by you if you use gpg
with automatic signing enabled.

Any changes made to /etc without apt-get will need to be committed/pushed in
place, which should be reflected in your local checkout as well.

When you are ready to contribute your changes upstream, please push to a fork
and make a pull request.

## Notes ##

  Use at your own risk. You may be eaten by a grue.

  Questions/Comments?

  Talk to us via:

  [Email](mailto://team@hashbang.sh) |
  [IRC](ircs://irc.hashbang.sh:6697/#!) |
  [Github](http://github.com/hashbang/)
