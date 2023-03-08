# Yubikey GPG Configuration

*For private keys stored to Yubikey*

(see also: [drduh's Yubikey Guide on GitHub](https://github.com/drduh/YubiKey-Guide))

## Required Components

For Arch-based distributions, the following components are required (currently all found in the community repo):
* pcsclite
* ccid
* hopenpgp-tools
* yubikey-personalization
* yubikey-manager-qt

Ensure that a suitable `gpg.conf` configuration file has been created or updated: (*`~/.gnupg/gpg.conf`*)

The pc/sc daemon must be running. 
* enable at boot: `sudo systemctl enable pcscd.service`
* start immediately: `sudo systemctl start pcscd.service`

---

## Loading Public Keys to the Keyring
*Public Key Retrieval*

### Key Anatomy
PGP keys are most commonly identified via their `fingerprint`. These fingerprints may or may not include spaces - the following examples are the most common ways keys are written:
* `74BD90B590F9AA984391707383308CA85B65951C`
* `74BD 90B5 90F9 AA98 4391 7073 8330 8CA8 5B65 951C`

Additionally, keys may be referred to by their "id" (or _"key id"_). A Key ID consists of the last four chunks from it's signature. Using the example above, the Key ID is:  `83308CA85B65951C`

```
Fingerprint:  74BD 90B5 90F9 AA98 4391 7073 8330 8CA8 5B65 951C
     Key ID:                                ^^^^ ^^^^ ^^^^ ^^^^
```

> ***<u>NOTE:</u>*** The last _<u>16 digits</u>_ are generally simply referred to as the "ID" - however, the last _<u>8 digits</u>_ are sometimes referred to as the "`Short Key ID`."  Obviously, more characters are preferred to ensure correctness.  

To make clear when a key is being referenced by it's "Key ID", you'll frequently see them displayed with a `0x` prefix:
* `0x83308CA85B65951C`

> Unlike fingerprints, it is unusual to see a Key ID printed with spaces.

---

### Key Server
Though there are many such servers, my preference is [keys.openpgp.org](https://keys.openpgp.org). Searches are performed using one of three identifiers:
* email address
* key id
* fingerprint

Fingerprint-based searches can include or omit spaces.

Public key for `bryan@dodd.dev`:
* https://keys.openpgp.org/vks/v1/by-fingerprint/74BD90B590F9AA984391707383308CA85B65951C

This link provides a public key file (`.asc` extension):

#### Downloading and Importing from Keyservers

```bash
$ gpg --keyserver hkps://keys.openpgp.org --recv-keys 0x83308CA85B65951C

# If you've not already imported a key:
gpg: key 83308CA85B65951C: public key "Bryan Dodd <bryan@dodd.dev>" imported
gpg: Total number processed: 1
gpg:               imported: 1

# If you've already previously imported a key, you'll see:
gpg: key 83308CA85B65951C: "Bryan Dodd <bryan@dodd.dev>" not changed
gpg: Total number processed: 1
gpg:              unchanged: 1
```

#### Direct Download from Web

Using a known public key URL, individual keys can be imported manually.
```bash
$ curl https://dodd.dev/whoami/bryandodd.asc | gpg --import

# New key:
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1367  100  1367    0     0   8603      0 --:--:-- --:--:-- --:--:--  8762
gpg: key 83308CA85B65951C: public key "Bryan Dodd <bryan@dodd.dev>" imported
gpg: Total number processed: 1
gpg:               imported: 1

# Already exists:
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  1367  100  1367    0     0   8603      0 --:--:-- --:--:-- --:--:--  8762
gpg: key 83308CA85B65951C: "Bryan Dodd <bryan@dodd.dev>" not changed
gpg: Total number processed: 1
gpg:              unchanged: 1

```

#### From Existing Key File

```bash
$ gpg --import bryandodd.asc
```

#### Direct Search of Key Server
If the Key ID is not already known but the associated address is, you can search based on the address and interactively import the key.

```bash
$ gpg --search-key bryan@dodd.dev

gpg: data source: https://keys.openpgp.org:443
(1) Bryan Dodd <bryan@dodd.dev>
     256 bit EDDSA key 0x83308CA85B65951C, created: 2022-05-28
Keys 1-1 of 1 for "bryan@dodd.dev".  Enter number(s), N)ext, or Q)uit > 1

gpg: key 0x83308CA85B65951C: public key "Bryan Dodd <bryan@dodd.dev>" imported
gpg: Total number processed: 1
gpg:               imported: 1
```

---

## Loading Private Key Stubs to the Keyring
*Private Key Retrieval*

Force GPG to scan the Yubikey and create key stubs for your private keys using the command below. This command will also be useful when switching between multiple Yubikeys with copies of the same key loaded to them.
```bash
$ gpg-connect-agent "scd serialno" "learn --force" /bye
```

Loading stubs can also be achieved with the following command, although this does not solve issues related to using multiple Yubikeys with identical copies of keys. 
```bash
$ gpg --card-status
```

---

## Key Trust
*Marking Your Key as Trusted*

With your keys imported, mark them as trusted:
```
$ gpg --edit-key bryan@dodd.dev

gpg (GnuPG) 2.2.41; Copyright (C) 2022 g10 Code GmbH
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret subkeys are available.

pub  ed25519/0x83308CA85B65951C
     created: 2022-05-28  expires: never       usage: C   
     trust: unknown       validity: unknown
ssb  ed25519/0x5B484E245400D8FF
     created: 2022-05-28  expires: never       usage: S   
     card-no: 0006 17473106
ssb  ed25519/0x2BA9D97DEB5285E8
     created: 2022-05-28  expires: never       usage: A   
     card-no: 0006 17473106
ssb  cv25519/0xFFEAEADFB4C98A69
     created: 2022-05-28  expires: never       usage: E   
     card-no: 0006 17473106
[ unknown] (1). Bryan Dodd <bryan@dodd.dev>

gpg> trust
pub  ed25519/0x83308CA85B65951C
     created: 2022-05-28  expires: never       usage: C   
     trust: unknown       validity: unknown
ssb  ed25519/0x5B484E245400D8FF
     created: 2022-05-28  expires: never       usage: S   
     card-no: 0006 17473106
ssb  ed25519/0x2BA9D97DEB5285E8
     created: 2022-05-28  expires: never       usage: A   
     card-no: 0006 17473106
ssb  cv25519/0xFFEAEADFB4C98A69
     created: 2022-05-28  expires: never       usage: E   
     card-no: 0006 17473106
[ unknown] (1). Bryan Dodd <bryan@dodd.dev>

Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu

Your decision? 5

Do you really want to set this key to ultimate trust? (y/N) y

pub  ed25519/0x83308CA85B65951C
     created: 2022-05-28  expires: never       usage: C   
     trust: ultimate      validity: unknown
ssb  ed25519/0x5B484E245400D8FF
     created: 2022-05-28  expires: never       usage: S   
     card-no: 0006 17473106
ssb  ed25519/0x2BA9D97DEB5285E8
     created: 2022-05-28  expires: never       usage: A   
     card-no: 0006 17473106
ssb  cv25519/0xFFEAEADFB4C98A69
     created: 2022-05-28  expires: never       usage: E   
     card-no: 0006 17473106
[ unknown] (1). Bryan Dodd <bryan@dodd.dev>
Please note that the shown key validity is not necessarily correct
unless you restart the program.

gpg> quit
```
Confirm key trust:
```bash
$ gpg --list-keys --with-subkey-fingerprint -vvv
$ gpg --list-secret-keys --with-subkey-fingerprint -vvv
```

---

## Update `gpg.conf`

With your keys loaded and trusted, optionally modify your `gpg.conf` file to include your default Key ID.


