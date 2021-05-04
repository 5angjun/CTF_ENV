FROM ubuntu:18.04
MAINTAINER psj <best_collin@naver.com>

ENV TZ Asia/Seoul
ENV PYTHONIOENCODING UTF-8
ENV LC_CTYPE C.UTF-8

RUN apt-get update && apt-get install -y netcat

RUN apt update
RUN apt install curl git wget file zsh sudo vim libssl-dev libffi-dev build-essential -y
RUN apt install python python-pip git curl wget vim zsh gdb python3 python3-pip  -y
RUN mkdir -p /tools 
RUN mkdir -p /set
RUN git clone https://github.com/longld/peda.git ~/peda
RUN git clone git://github.com/Mipu94/peda-heap.git ~/peda-heap
RUN git clone https://github.com/scwuaptx/Pwngdb.git  ~/tools
RUN git clone https://github.com/Psj0221/CTF_ENV.git ~/set

RUN dpkg --add-architecture i386 &&\
       apt-get update &&\
       apt-get install python3-dev ruby binutils-multiarch -y &&\
       apt-get install libc6:i386 libncurses5:i386 libstdc++6:i386 -y
RUN pip3 install unicorn
RUN pip3 install keystone-engine 
RUN pip3 install
RUN pip3 install capstone ropper

RUN pip install pwntools

RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true

RUN mkdir -p "$HOME/.zsh"
RUN git clone https://github.com/sindresorhus/pure.git "$HOME/.zsh/pure"
RUN echo "fpath+=("$HOME/.zsh/pure")\nautoload -U promptinit; promptinit\nprompt pure" >> ~/.zshrc

RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git
RUN echo "source ./zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc

RUN git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
RUN echo "source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc
RUN echo "ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=111'" >> ~/.zshrc

RUN cat ~/set/vimrc_set >> ~/.vimrc
RUN cat ~/set/zshrc_set >> ~/.zshrc
RUN cat ~/set/gdbinit_set >> ~/.gdbinit

RUN apt-get install ruby -y
RUN gem install one_gadget

