FROM debian

COPY --from=caddy:latest /usr/bin/caddy /usr/bin/caddy

ENV CFLAGS="-ggdb3"

ENV PHPIZE_DEPS \
    autoconf \
    dpkg-dev \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkg-config \
    re2c

RUN apt-get update && \
    apt-get -y --no-install-recommends install \
    $PHPIZE_DEPS \
    build-essential \
    automake \
    ca-certificates \
    libargon2-dev \
    libonig-dev \
    libreadline-dev \
    libsodium-dev \
    libsqlite3-dev \
    libssl-dev \
    libxml2-dev \
    zlib1g-dev \
    bison \
    # Dev tools \
    openssl \
    git \
    clang \
    llvm \
    gdb \
    valgrind \
    neovim \
    zsh \
    libtool-bin && \
    echo 'set auto-load safe-path /' > /root/.gdbinit && \
    echo '* soft core unlimited' >> /etc/security/limits.conf \
    && \
    apt-get clean

RUN cd /usr/src/ && \
    git clone --recurse-submodules -j$(nproc) https://github.com/nghttp2/nghttp2 && \
    cd nghttp2 && \
    autoreconf -i && \
    automake && \
    autoconf && \
    ./configure --enable-debug && \
    make -j$(nproc)  && \
    make install

RUN cd /usr/src/ && \
    git clone https://github.com/curl/curl && \
    cd curl && \
    autoreconf -fi && \
    ./configure --enable-debug --with-openssl && \
    make -j$(nproc) && \
    make install

RUN cd /usr/src/ && \
    git clone --branch=PHP-8.2 https://github.com/php/php-src.git && \
    cd php-src && \
    # --enable-embed is only necessary to generate libphp.so, we don't use this SAPI directly
    ./buildconf -f && \
    ./configure \
        --enable-debug \
        --with-curl \
        --with-readline && \
    make -j$(nproc) && \
    make install && \
    ldconfig && \
    php --version

WORKDIR /usr/src/php-src

CMD [ "zsh" ]
