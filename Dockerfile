# You may need to run "docker pull mathworks/matlab-deep-learning:r2022b" and "docker pull centos:7" before this build
FROM mathworks/matlab-deep-learning:r2022b as builder
FROM centos:7

# Copy matlab to container
COPY --from=builder /opt/matlab/R2022b /opt/matlab/R2022b
RUN ln -s /opt/matlab/R2022b/bin/matlab /usr/bin/matlab
ENV USER=matlab
ARG PASSWD=matlab
ENV DISPLAY=1280x1024

# Install some pre-dependencies
RUN yum makecache && \
          yum install -y epel*  \
          openssh-server \
          policycoreutils-python \
          tigervnc-server \
          xfce4-session \
          xfce4-panel \
          xfce4-terminal \
          xfce4-settings \
          xfdesktop \
          xfce4-appfinder \
          xorg-x11-server-utils \
          mesa-dri-drivers \
          mesa-libGL-devel \
          mesa-libGL \
          mesa-libGLU \
          mesa-libGLU-devel \
          libtiff \
          libtiff-devel \
          libjepg \
          libjpeg-devel \
          polkit-gnome \
          which \
          gcc-c++ \
          gcc \
          wget \
          openssl-devel \
          libXt-devel \
          libXext-devel \
          libX11-devel \
          libICE-devel \
          libSM-devel \
          libXi-devel \
          libXrender-devel \
          libXrandr-devel \
          libXtst-devel \
          libXfixes-devel \
          libXcursor-devel \
          libXinerama-devel \
          libXau-devel \
          fontconfig-devel \
          freetype-devel \
          glib2-devel \
          dbus-devel \
          zlib-devel \
          make \
          git \
          bzip2 \
          python \
          python3-pip \
          python3-devel \
          unzip \
          xorg-x11-server-Xorg \
          xorg-x11-xauth \ 
          xorg-x11-apps \ 
          systemd \
          sudo \
          libffi-devel \
          firefox && yum clean all && \
          yum groupinstall -y "X Window system" && \
          yum groupinstall -y xfce && yum clean all && \ 
          yum --enablerepo=epel* -y install novnc && \ 
          yum clean all && \
          rm -rf /var/cache/yum/*

# build vnc and noVNC for docker graphical operation
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
RUN git clone https://github.com/novnc/websockify && pip3 install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple && \
        pip3 install numpy==1.19.5 setuptools_rust cryptography websockify -i https://pypi.tuna.tsinghua.edu.cn/simple && \ 
        cd /websockify && pip3 install . -i https://pypi.tuna.tsinghua.edu.cn/simple

RUN /bin/dbus-uuidgen --ensure

RUN useradd -m --shell /bin/bash $USER && \
          echo "$USER:$PASSWD" | chpasswd && \
          echo "$USER ALL=(ALL) ALL" >> /etc/sudoers

RUN openssl req -x509 -nodes -newkey rsa:2048 -keyout /home/$USER/novnc.pem -out /home/$USER/novnc.pem -days 365 -subj /C=CN/O="forsrc"/OU="forsrc"/CN="forsrc"/ST="forsrc"/L="forsrc"

RUN mkdir /home/$USER/.vnc
RUN echo '#!/bin/sh' > /home/$USER/.vnc/xstartup
RUN echo '/usr/bin/startxfce4' >> /home/$USER/.vnc/xstartup
RUN echo "${PASSWD}" | vncpasswd -f > /home/$USER/.vnc/passwd
RUN touch /home/$USER/.Xauthority
RUN chown -R $USER:$USER /home/$USER && \
          chmod 775 /home/$USER/.vnc/xstartup && \
          chmod 600 /home/$USER/.vnc/passwd

RUN echo "sudo rm -rf /tmp/.X1-lock /tmp/.X11-unix"  > /start.sh
RUN echo "vncserver -kill :1"                                       >> /start.sh
RUN echo "vncserver -geometry \$DISPLAY :1"   >> /start.sh
RUN echo "websockify --web=/usr/share/novnc/  6080 localhost:5901" >> /start.sh

RUN chown -R $USER:$USER /start.sh
RUN chmod +x                              /start.sh

EXPOSE 5901
EXPOSE 6080

# build Qt 4.7.3, because of vaa3d and some mex function in CellExplorer
RUN wget http://download.qt.io/archive/qt/4.7/qt-everywhere-opensource-src-4.7.3.tar.gz && \
    tar -zxvf qt-everywhere-opensource-src-4.7.3.tar.gz && \
    cd qt-everywhere-opensource-src-4.7.3 && \
    ./configure -opensource -confirm-license  -opengl && \
    make && \
    make install && \
    cd .. && \
    rm -rf qt-everywhere-opensource-src-4.7.3 && \
    rm -rf qt-everywhere-opensource-src-4.7.3.tar.gz

# build gcc 9.4.0, because matlab from mathworks/matlab-deep-learning container needs newer version of libstdc++.so.6
RUN wget --no-check-certificate https://ftp.gnu.org/gnu/gcc/gcc-9.4.0/gcc-9.4.0.tar.gz && \
        tar -zxvf gcc-9.4.0.tar.gz && \
        cd /gcc-9.4.0 && \
        ./contrib/download_prerequisites &&\
        mkdir build/ &&\
        cd build &&pwd&& ls ../ &&\ 
        ../configure --disable-multilib && \
        make && \ 
        make install && \
        cd ../../ && \
        rm -rf gcc-9.4.0.tar.gz && \
        rm -rf gcc-9.4.0


# build libtiff 3.9.7, because of vaa3d and some mex function in CellExplorer
RUN wget http://download.osgeo.org/libtiff/tiff-3.9.7.tar.gz && \
    tar -zxvf tiff-3.9.7.tar.gz && \
    cd tiff-3.9.7 && \
    ./configure && \
    make && \
    make install && \
    cd .. && \
    rm -rf tiff-3.9.7 && \
    rm -rf tiff-3.9.7.tar.gz

# CellExplorer
COPY CellExplorer.tar.gz /home/matlab/CellExplorer.tar.gz
RUN cd /home/matlab/ &&\
      tar -zxvf CellExplorer.tar.gz &&\
      rm -rf CellExplorer.tar.gz &&\
      chown -R matlab:matlab /home/matlab/


#ENTRYPOINT ["/usr/bin/vncserver", "-fg"]
ENV VNC_PASSWORD=matlab
CMD ["sh", "-c", "/start.sh"]

      

COPY --from=builder /home/matlab/Documents /home/matlab/Documents
COPY --from=builder /home/matlab/Desktop/MATLAB.desktop /home/matlab/Desktop/MATLAB.desktop
RUN chown matlab:matlab /home/matlab/Documents
RUN sed -i "2iaddpath(genpath('/home/matlab/CellExplorer'));" /home/matlab/Documents/MATLAB/startup.m &&\ 
    sed -i "3idip_initialise();" /home/matlab/Documents/MATLAB/startup.m && \
	sed -i 's|Path=/home/matlab/Documents/MATLAB|Path=/home/matlab/CellExplorer|g' /home/matlab/Desktop/MATLAB.desktop && \
    chown matlab:matlab /home/matlab/Documents/MATLAB/startup.m /home/matlab/Desktop/MATLAB.desktop && \
	chmod 755 /home/matlab/Documents/MATLAB/startup.m /home/matlab/Desktop/MATLAB.desktop

WORKDIR /home/$USER
USER $USER
ENV VARIANTmatlab=matlabLNU
ENV PATH=/home/matlab/CellExplorer/vaa3d:$PATH
ENV LD_LIBRARY_PATH=/usr/local/lib64:/usr/local/lib:/home/matlab/CellExplorer/vaa3d:/home/matlab/CellExplorer/dip/Linuxa64/lib
