`Ask yourself if this is really what you want to do. It might be more sensible to delete just the files and only the ones which haven't been accessed for - say - 48 hours. Is this possible? Yes, it is: use the "find" command for that:`

```diff
- the command :~# find /tmp -type f -atime +2 -exec rm -f {} \;
```
# Specific minutes and day's
 - for this example, the file is not using from 37 min
```diff
- the command :~# find /tmp -type f -mmin +37 -exec rm -fv {} \;
```
- Removing files older than 7 days
```diff
- the command :~# find /tmp -type f -mtime +7 -exec rm -fv {} \; 
```
# Specific file
- Removing `.gz` files older than 7 days

```diff
- the command :~# find /path/to/ -type f -mtime +7 -name '*.gz' -execdir rm -- '{}' \;
```
