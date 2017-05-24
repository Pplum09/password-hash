# Basic Password Hash

Over the weekend I learned that companies store hashes of user passwords instead of the actual plaintext password. I mean, no duh right? It's kind of cool because companies never actually know your passwords and a compromised app wouldn't be that big of a deal (I hope).

The program stores user information in a local sqlite database. Inputing your password on your own local instance of this program will not allow me or anyone outside of your computer to see it. Passwords are MD5 hashed and stored in the database upon account creation. On login, the program just varifies if the combination of username + hashed password exists!

## Installation

Currently, I'm not too sure if a regular clone of this repo will give you a plug and play working version of this program. I'll have to write a gemfile or a script to auto install all dependancies in the future.

## Usage

```ruby
# to run the program
ruby auth.rb
```
```linux
# menu
# input number to select
1. Login
2. New Account
3. Exit
Selection:
```

When entering in credentials, the password fields are set to not display what you are typing. Just type your password and press enter. When creating a new user, the usernamename must not already exist within the database and the password must be inputed twice for safety.

The current accounts are:
username: a
password: a

username: b
password: b
## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D
