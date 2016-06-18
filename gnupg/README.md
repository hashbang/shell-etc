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

	cat ../../password-store/.gpg-id | cut -d' ' -f1 | \
		xargs gpg --export --export-options export-minimal,export-clean -o hashbang-admins.gpg
