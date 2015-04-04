FROM sequenceiq/spark:1.3.0
RUN yum install -y python-setuptools.noarch gcc-c++.x86_64 python-devel freetype-devel libpng-devel lapack-devel wget git
RUN wget -qO- http://people.redhat.com/bkabrda/scl_python27.repo >> /etc/yum.repos.d/scl.repo
RUN yum install -y python27
RUN source /opt/rh/python27/enable &&\
  easy_install-2.7 pip &&\
  pip2.7 install matplotlib==1.4.3 scipy==0.15.1 pandas==0.13 scikit-learn==0.14.1 &&\
  pip2.7 install ipython[all]

ENV HOME /root
WORKDIR $HOME
RUN echo -e "\n\n\n\nlogin.miptcloud.com\n\n" | openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem
RUN source /opt/rh/python27/enable &&\
  ipython profile create default &&\
  python -c "from IPython.lib import passwd; print passwd('lambda03')"  > /root/.ipython/profile_default/nbpasswd.txt &&\
\
  echo -e "# Notebook config\nc.NotebookApp.certfile = u'/root/mycert.pem'\nc.NotebookApp.ip = '*'\nc.NotebookApp.open_browser = False\n# It is a good idea to put it on a known, fixed port\nc.NotebookApp.port = 8000\n\nPWDFILE='/root/.ipython/profile_default/nbpasswd.txt'\nc.NotebookApp.password = open(PWDFILE).read().strip()" >> /root/.ipython/profile_default/ipython_notebook_config.py && \
\
  echo -e "# Configure the necessary Spark environment\nimport os\nos.environ['SPARK_HOME'] = '/usr/local/spark'\n# And Python path\nimport sys\nsys.path.insert(0, '/usr/local/spark/python')\nsys.path.insert(0, '/usr/local/spark/python/lib/py4j-0.8.2.1-src.zip')\n\n# Detect the PySpark URL\n#CLUSTER_URL = open('/root/spark-ec2/cluster-url').read().strip()\n" > /root/.ipython/profile_default/startup/00-pyspark-setup.py &&\
\
  wget https://github.com/mathjax/MathJax/archive/v2.0-latest.zip &&\
  python -m IPython.external.mathjax v2.0-latest.zip &&\
  rm v2.0-latest.zip
