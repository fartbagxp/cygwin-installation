## strace

strace -e openat wget -vv https://classic.yarnpkg.com | grep cert

strace -e network -ff dig somename.com
