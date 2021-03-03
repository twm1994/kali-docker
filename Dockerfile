# original file: https://github.com/LiveOverflow/pwn_docker_example/blob/master/challenge/Dockerfile

# sudo docker build -t system_health_check .
# sudo docker run -d -p 1024:1024 --rm -it system_health_check

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

#RUN $ZSH -c /home/$USR/.zshrc

# optional kali tools, spilt into multi commits for fast rebuild in case of typos
RUN apt-get install -y dnsenum dnsmap dnswalk

# wireshark, sslh are installed interactively
# RUN apt-get install -y wireshark sslh

RUN apt-get install -y binwalk radare2 gdb

#RUN apt-get install -y metasploit-framework

RUN apt-get install -y python3 git man-db

USER $USR

ENTRYPOINT ["/bin/zsh"]
#CMD ./ynetd -p 1024 ./system_health_check
