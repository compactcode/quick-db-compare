# What

This project provides a simple way to examine database changes resulting from an arbitrary set of commands.

# How

Copy and update the database config.

```
cp sample-database.yml database.yml
```

Take a snapshot, execute some commands, take another snapshot.

```
ruby snapshot.rb && (cd ../another-project && rake db:seed_fu) && ruby snapshot.rb
```

Compare the two snapshots.

```
opendiff before/ after/
```