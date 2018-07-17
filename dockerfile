FROM  nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04


RUN apt-get clean    && \
	cd /var/lib/apt   &&   mkdir -p lists/partial      &&\
	apt-get clean   && \   
	apt-get update   &&\     
	apt-get install -y --no-install-recommends \
	build-essential cmake  git  curl vim  wget  tree  \
	python-dev  	python-pip  python-tk\
	python3-dev  python3-pip   python3-tk  \
	libopenblas-dev   liblapack-dev   \
	mlocate 	htop  	tar   zip   openssh-server  \
	screen  unzip  graphviz   ca-certificates  python-setuptools   swig \
    libjpeg-dev 	libpng-dev  libopencv-dev   &&\
    rm -rf /var/lib/apt/lists/*   

RUN pip3 install  --no-cache-dir   wheel  setuptools
RUN pip3 install   --no-cache-dir    numpy   scipy   matplotlib  pillow  scikit-learn  Cython    easydict   hickle  pyyaml   scikit-image    \
	lxml  tensorflow_gpu==1.4.1   h5py   pydot_ng   keras==2.1.2  opencv-python   tqdm  flask

RUN	pip install  --no-cache-dir   wheel  setuptools
RUN	pip install   --no-cache-dir    numpy   scipy   matplotlib  pillow  scikit-learn  Cython    easydict   hickle  pyyaml   scikit-image    \
	lxml  tensorflow_gpu==1.4.1   h5py   pydot_ng   keras==2.1.2  opencv-python   tqdm  flask
 


RUN mkdir /var/run/sshd     &&   echo 'root:password' |chpasswd     &&\
	sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config     &&\
	sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config  




RUN  mkdir -p /_backup  && cd /_backup   && \
	wget  http://download.osgeo.org/proj/proj-4.8.0.tar.gz  &&  \
	tar zxvf proj-4.8.0.tar.gz  &&  cd proj-4.8.0  &&  \
	chmod +x * &&  ./configure  &&  make -j$(nproc)   &&  make install  &&   \
	make clean	&&\
	cd /_backup  &&  wget   http://download.osgeo.org/gdal/2.2.3/gdal223.zip   &&  \
	unzip gdal223.zip   &&  \
	cd gdal-2.2.3 && chmod +x * &&  ./configure --with-static-proj4=/usr/local/lib/libproj.a  --with-python=/usr/bin/python3   && \
	make  -j8    &&  make install  && \
	cd swig/python  && \
	chmod +x   * && \
	make  &&\
	python3 setup.py build   && \
	python3 setup.py install   && \
	rm -rf /_backup/gdal-2.2.3	&&\
	rm -rf /_backup/proj-4.8.0	&&\
	rm -rf /_backup/gdal223.zip 	&&\
	env  > /_backup/env.txt

EXPOSE  22
EXPOSE  5000
EXPOSE  6006
CMD    ["/usr/sbin/sshd", "-D"]
