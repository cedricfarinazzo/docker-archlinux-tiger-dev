FROM archlinux
LABEL authors="Cédric Farinazzo <cedric.farinazzo@gmail.com>"

RUN pacman --noconfirm -Sy && \
    pacman --noconfirm -S wget curl git && \
    pacman --noconfirm -S autoconf automake make git gcc clang && \
    pacman --noconfirm -S flex bison gettext && \
    pacman --noconfirm -S python && \
    pacman --noconfirm -S boost boost-libs && \
    pacman --noconfirm -S valgrind doxygen ocaml

RUN wget https://www.lrde.epita.fr/~tiger/download/bison-3.2.1.52-cd4f7.tar.gz && \
    tar -xvf bison-3.2.1.52-cd4f7.tar.gz && \
    cd bison-3.2.1.52-cd4f7 && \
    ./configure && \
    make -j4 && \
    make install && cd - && rm -rf bison-*

ENTRYPOINT /bin/bash
