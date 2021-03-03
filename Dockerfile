# original file: https://github.com/LiveOverflow/pwn_docker_example/blob/master/challenge/Dockerfile

FROM kalilinux/kali-rolling:latest

# user, group, etc.
ENV USR=kali
ENV GRP=kali
ENV PASSWD=kali
ENV ZSH=/usr/bin/zsh

# cannot use apt; no stable CLI warning
RUN apt-get update

RUN apt-get install -y zsh zsh-autosuggestions zsh-syntax-highlighting  vim

RUN useradd -d /home/$USR -m -p $PASSWD -s $ZSH $USR
RUN echo "$USR:$GRP" | chpasswd

RUN usermod -p root -s $ZSH root
RUN echo "root:root" | chpasswd

WORKDIR /home/$USR

# without this files in ~ will own by the host user
RUN chown -R root:root /home/$USR

RUN chsh -s /bin/zsh $USR

COPY --chown=$USR:$GRP .zshrc .

# optional kali tools
RUN apt-get install -y dnsenum dnsmap dnswalk binwalk radare2 gdb python3 python3-pip git man-db john zip ziptool zlib1g zlib1g-dev build-essential jq strace ltrace curl wget gcc dnsutils netcat gcc-multilib

USER $USR

ENTRYPOINT ["/bin/zsh"]
