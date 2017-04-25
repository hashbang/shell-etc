# #! role keyrings

This folder contains OpenPGP keyrings that correspond to
roles in Hashbang.  The only current role is “admins”,
and the keyring is used to check signatures on data that is
fetched from Git.



## Creating and updating keyrings

Each keyring is a OpenPGP binary file, and keys should be
exported with options `export-minimal` and `export-clean`.

For instance, the `hashbang-admins.gpg` keyring can be
generated as follows, from the list of keys in the `pass(1)`
password database:

  export GNUPGHOME=$(mktemp -d);
  cat ~/.password-store/Hashbang/.gpg-id | cut -d' ' -f1 | \
    xargs gpg --keyserver pgp.mit.edu --recv-key
  gpg --export > hashbang-admins.gpg
  unzer GNUPGHOME
