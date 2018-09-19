FROM ubuntu:16.04
MAINTAINER DoubleMice <doublemice@qq.com>


# RUN sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list

RUN dpkg --add-architecture i386 && \
    apt-get -y update && \
    apt install -y \
    libc6:i386 \
    libc6-dbg:i386 \
    libc6-dbg \
    lib32stdc++6 \
    g++-multilib \
    cmake \
    net-tools \
    libffi-dev \
    libssl-dev \
    python3-pip \
    python-pip \
    python-capstone \
    ruby2.3 \
    tmux \
    strace \
    ltrace \
    nasm \
    wget \
    radare2 \
    gdb \
    gdb-multiarch \
    netcat \
    socat \
    git \
    patchelf \
    gawk \
    qemu \
    file --fix-missing && \
    rm -rf /var/lib/apt/list/*


RUN cd && mkdir .pip && echo "[global]\nindex-url = https://pypi.tuna.tsinghua.edu.cn/simple/\n" > /root/.pip/pip.conf

RUN pip install --upgrade pip
RUN pip3 install --no-cache-dir \
    ropper \
    unicorn \
    keystone-engine \
    capstone

RUN pip install --upgrade setuptools && \
    pip install --no-cache-dir --ignore-installed \
    ropgadget \
    pwntools \
    zio \
    angr \
    lief \
    z3-solver \
    apscheduler && \
    pip install --upgrade pwntools

RUN gem install \
    one_gadget && \
    rm -rf /var/lib/gems/2.3.*/cache/* && \
    git clone https://github.com/pwndbg/pwndbg && \
    cd pwndbg && sed -i s/sudo//g setup.sh && \
    chmod +x setup.sh && ./setup.sh && \
    git clone https://github.com/skysider/LibcSearcher.git LibcSearcher && \
    cd LibcSearcher && git submodule update --init --recursive && \
    python setup.py develop && cd libc-database && ./get || ls

WORKDIR /root

# RUN cd /root && mkdir glibc && cd glibc && mkdir 2.24 && cd && \
#     wget http://mirrors.ustc.edu.cn/gnu/libc/glibc-2.24.tar.gz && \
#     tar xf glibc-2.24.tar.gz && cd glibc-2.24 && mkdir build && cd build && \
#     ../configure --prefix=/root/glibc/2.24/ --disable-werror --enable-debug=yes && \
#     make && make install && cd ../../ && rm -rf glibc-2.24 && rm glibc-2.24.tar.gz


RUN chmod a+x /root/linux_server /root/linux_server64
ENTRYPOINT ["/bin/bash"]

