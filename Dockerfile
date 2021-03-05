# original file: https://github.com/LiveOverflow/pwn_docker_example/blob/master/challenge/Dockerfile

# change the docker run command as needed
# docker run --name kali-ctf -it -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v $HOME/.Xauthority:/home/kali/.Xauthority:rw kali-boo

FROM kalilinux/kali-rolling:latest

# user, group, etc.
ENV USR=kali
ENV GRP=kali
ENV PASSWD=kali
ENV ZSH=/usr/bin/zsh

# skip interactive configuration dialogs
ENV DEBIAN_FRONTEND noninteractive

# cannot use apt; no stable CLI warning
RUN apt-get update

RUN apt-get install -y --no-install-recommends zsh zsh-autosuggestions zsh-syntax-highlighting vim

RUN useradd -d /home/$USR -m -p $PASSWD -s $ZSH $USR
RUN echo "$USR:$GRP" | chpasswd

RUN usermod -p root -s $ZSH root
RUN echo "root:root" | chpasswd

WORKDIR /home/$USR

# without this files in ~ will own by the host user
RUN chown -R $USR:$USR /home/$USR
RUN chown root:root /home/$USR/..

RUN chsh -s /bin/zsh $USR

COPY --chown=$USR:$GRP .zshrc .

# optional kali tools, install as needed
# write new "RUN" instruction for incremental image build
RUN apt-get install -y --no-install-recommends dnsenum dnsmap dnswalk binwalk radare2 gdb python3 python3-pip git man-db john zip ziptool zlib1g zlib1g-dev build-essential jq strace ltrace curl wget gcc dnsutils netcat gcc-multilib wireshark xauth metasploit-framework

RUN apt-get install -y --no-install-recommends python3-dev libssl-dev libffi-dev && python3 -m pip install --upgrade pip && python3 -m pip install --upgrade pwntools

RUN apt-get autoremove -y --purge

# allow non-root users to capture network traffic
#RUN setcap 'CAP_NET_RAW+eip CAP_NET_ADMIN+eip' /usr/bin/

USER $USR

EXPOSE 8887

ENTRYPOINT ["/bin/zsh"]
