FROM archlinux
LABEL authors="Cédric Farinazzo <cedric.farinazzo@gmail.com>"

# Install dependencies
RUN pacman --noconfirm -Syyu
RUN pacman --noconfirm -S git gcc gcc-libs lib32-gcc-libs clang \
                        glib2 pkgconf make autoconf automake \
                        gettext bison flex python \
                        boost boost-libs llvm \
                        valgrind doxygen ocaml sudo fakeroot && yes | pacman -Scc

# Add user, group sudo
RUN /usr/sbin/groupadd --system sudo && \
    /usr/sbin/useradd -m --groups sudo user && \
    /usr/sbin/sed -i -e "s/Defaults    requiretty.*/ #Defaults    requiretty/g" /etc/sudoers && \
    /usr/sbin/echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# Install yay
RUN git clone https://aur.archlinux.org/yay.git && \
    chown -R user:user yay && \
    cd yay && sudo -u user makepkg -si --noconfirm --nocheck && \
    cd - && rm -rf yay

# Install aur dependencies
RUN sudo -u user yay -S --cleanafter --noconfirm --removemake \
                        --mflags --nocheck bison-epita havm-epita \
                        monoburg-git nolimips-git

ENTRYPOINT /bin/bash
