FROM archlinux
LABEL authors="Cédric Farinazzo <cedric.farinazzo@gmail.com>"

# Install dependencies
RUN pacman --noconfirm -Syyu && \
    pacman --noconfirm -S wget curl git gcc gcc-libs lib32-gcc-libs clang \
                        glib2 pkgconf make autoconf automake \
                        flex bison gettext python \
                        boost boost-libs llvm \
                        valgrind doxygen ocaml && yes | pacman -Scc

# fix libffi
RUN ln -sf /usr/lib/libffi.so /usr/lib/libffi.so.6
RUN ln -sf /usr/lib/libnettle.so /usr/lib/libnettle.so.7
RUN ln -sf /usr/lib/libhogweed.so /usr/lib/libhogweed.so.5

# Install bison epita
RUN wget https://www.lrde.epita.fr/~tiger/download/bison-3.2.1.52-cd4f7.tar.gz -O /tmp/bison.tar.gz && \
    mkdir /tmp/bison && tar -xvf /tmp/bison.tar.gz -C /tmp/bison && \
    cd /tmp/bison/bison-3.2.1.52-cd4f7 && \
    $PWD/configure && \
    make -j4 && \
    make install && cd - && rm -rf /tmp/bison*

# Install havm epita
RUN git clone https://gitlab.lrde.epita.fr/tiger/havm.git /tmp/havm && \
    pacman --noconfirm -S ghc ghc-static happy gmp lib32-glibc && cd /tmp/havm && \
    $PWD/bootstrap && $PWD/configure --prefix=/usr && \
    make -j4 && make install && \
    pacman --noconfirm -Rsn ghc ghc-static happy && yes | pacman -Scc && \
    cd - && rm -rf /tmp/havm

# Install monoburg
RUN git clone https://gitlab.lrde.epita.fr/tiger/monoburg.git /tmp/monoburg && \
    cd /tmp/monoburg && \
    $PWD/bootstrap && $PWD/configure --prefix=/usr && \
    make -j4 && make install && \
    cd - && rm -rf /tmp/monoburg

# Install nolimips
RUN git clone https://gitlab.lrde.epita.fr/tiger/nolimips.git /tmp/nolimips && \
    cd /tmp/nolimips && \
    $PWD/bootstrap && $PWD/configure --prefix=/usr && \
    make -j4 && make install && \
    cd - && rm -rf /tmp/nolimips

ENTRYPOINT /bin/bash
