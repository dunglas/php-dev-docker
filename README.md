# Docker Image to Hack the PHP Interpreter

A convenient Docker image to track PHP bugs (segmentation faults), to develop extensions or the PHP interpreter itself.

## Build

```
git clone https://github.com/dunglas/php-dev-docker
cd php-dev-docker
docker build -t php-dev .
```

## Run

Basic usage:

```
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -it php-dev
```

### Debug a Local PHP Script Using GDB

```
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v ./:/app/ -it php-dev gdb php /app/my-script.php
```

Then, type `r` to execute the script.

If the program segfaults, type `bt` to get a backtrace.

More information:

* [Debugging PHP with GDB (PHP Internals Book)](https://www.phpinternalsbook.com/php7/debugging.html)
* [GDB User Manual](https://sourceware.org/gdb/current/onlinedocs/gdb.html/)

### Use Your Custom Forks of C Projects

Start the container with volumes containing your local sources of PHP, curl and/or nghttp2:

```
docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v ~/workspace/php-src:/usr/src/php-src -v ~/workspace/curl:/usr/src/curl -v ~/workspace/nghttp2:/usr/src/nghttp2 -it php-dev
```

## Tools Included

Base image: Debian

Libraries (Git repositories, and compiled versions with debug symbols):

* the PHP Interpreter
* `libcurl`
* `nghttp2`

Development tools:

* GCC
* LLVM
* GDB
* Valgrind
* neovim
* Git
* zsh
* Caddy
* OpenSSL

## Credits

Created by [Kévin Dunglas](https://dunglas.dev).
Sponsored by [Les-Tilleuls.coop](https://les-tilleuls.coop).
