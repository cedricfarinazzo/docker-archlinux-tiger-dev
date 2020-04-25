FROM archlinux
LABEL authors="Cédric Farinazzo <cedric.farinazzo@gmail.com>"

# Install dependencies
RUN pacman --noconfirm -Sy && \
    pacman --noconfirm -S wget curl git gcc clang make autoconf automake \
                        flex bison gettext python \
                        boost boost-libs llvm libffi \
                        valgrind doxygen ocaml && yes | pacman -Scc
# fix libffi
RUN ln -sf /usr/lib/libffi.so.7 /usr/lib/libffi.so.6

# Install bison epita
RUN wget https://www.lrde.epita.fr/~tiger/download/bison-3.2.1.52-cd4f7.tar.gz -O /tmp/bison.tar.gz && \
    mkdir /tmp/bison && tar -xvf /tmp/bison.tar.gz -C /tmp/bison && \
    cd /tmp/bison/bison-3.2.1.52-cd4f7 && \
    $PWD/configure && \
    make -j4 && \
    make install && cd - && rm -rf /tmp/bison*

# install havm epita
RUN git clone https://gitlab.lrde.epita.fr/tiger/havm.git /tmp/havm && \
    pacman --noconfirm -S ghc ghc-static happy gmp lib32-glibc && cd /tmp/havm && \
    $PWD/bootstrap && $PWD/configure --prefix=/usr && \
    make -j4 && make install && \
    pacman --noconfirm -Rsn ghc ghc-static happy && yes | pacman -Scc && \
    cd - && rm -rf /tmp/havm

ENTRYPOINT /bin/bash
