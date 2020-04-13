FROM archlinux
LABEL authors="Cédric Farinazzo <cedric.farinazzo@gmail.com>"

# Install dependencies
RUN pacman --noconfirm -Sy && \
    pacman --noconfirm -S wget curl git gcc clang make autoconf automake \
                        flex bison gettext python \
                        boost boost-libs llvm libffi \
                        valgrind doxygen ocaml

# fix libffi
RUN ln -sf /usr/lib/libffi.so.7 /usr/lib/libffi.so.6

# Install bison epita
RUN wget https://www.lrde.epita.fr/~tiger/download/bison-3.2.1.52-cd4f7.tar.gz && \
    tar -xvf bison-3.2.1.52-cd4f7.tar.gz && \
    cd bison-3.2.1.52-cd4f7 && \
    ./configure && \
    make -j4 && \
    make install && cd - && rm -rf bison-*

# install havm epita
RUN git clone https://gitlab.lrde.epita.fr/tiger/havm.git && \
    pacman --noconfirm -S ghc ghc-static happy gmp && cd havm && \
    ./bootstrap && ./configure --prefix=/usr && \
    make -j4 && make install && \
    pacman --noconfirm -Rsn ghc ghc-static happy && \
    cd - && rm -rf havm

ENTRYPOINT /bin/bash
