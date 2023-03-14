###################################################
### RHEL 8
####################################################

ssh admin@192.168.100.48
ssh admin@192.168.100.45
ssh admin@192.168.100.51
ssh admin@192.168.100.52
# Verificar subcripcion activa
sudo subscription-manager list
###################################################
### Instalar OpenJDK 8
###################################################
sudo dnf install java-11-openjdk-devel -y
# Si existe una version de Java instalada, debe elegir la 11
<<COMMENT
sudo update-alternatives --config 'java'
[admin@atcertext-spark_01 ~]$ sudo update-alternatives --config 'java'
[sudo] password for admin: 

There are 2 programs which provide 'java'.

  Selection    Command
-----------------------------------------------
*+ 1           java-1.8.0-openjdk.x86_64 (/usr/lib/jvm/java-1.8.0-openjdk-1.8.0.302.b08-3.el8.x86_64/jre/bin/java)
   2           java-11-openjdk.x86_64 (/usr/lib/jvm/java-11-openjdk-11.0.18.0.10-2.el8_7.x86_64/bin/java)

Enter to keep the current selection[+], or type selection number: 2
[admin@atcertext-spark_01 ~]$ java -version
openjdk version "11.0.18" 2023-01-17 LTS
OpenJDK Runtime Environment (Red_Hat-11.0.18.0.10-2.el8_7) (build 11.0.18+10-LTS)
OpenJDK 64-Bit Server VM (Red_Hat-11.0.18.0.10-2.el8_7) (build 11.0.18+10-LTS, mixed mode, sharing)
COMMENT
###################################################
### Instalar Apache Spark StandAlone
###################################################
# Descarga de Apache Spark
cd /opt
#sudo wget https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz
# En el 2023 ha sido archivada el instalador, se ubica en:
sudo wget https://archive.apache.org/dist/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz
# Descomprir en carpeta /opt
sudo tar -xvf spark-3.3.0-bin-hadoop3.tgz
sudo ln -s /opt/spark-3.3.0-bin-hadoop3 /opt/spark
# Crear usuario Spark
sudo useradd spark
# Otorgar permisos Spark a carpeta Spark
sudo chown -R spark:spark /opt/spark*
# Crear servicio Master
sudo vi /etc/systemd/system/spark-master.service
## Archivo Master service - atprodext-spark-01 192.168.100.48
[Unit]
Description=Apache Spark Master
After=network.target

[Service]
Type=forking
User=spark
Group=spark
ExecStart=/opt/spark/sbin/start-master.sh
ExecStop=/opt/spark/sbin/stop-master.sh

[Install]
WantedBy=multi-user.target

# Crear servicio Slave - atprodext-spark-01, atprodext-spark-02,atprodext-spark-03 y atprodext-spark-04
sudo vi /etc/systemd/system/spark-slave.service
## Archivo Slave service
[Unit]
Description=Apache Spark Slave
After=network.target

[Service]
Type=forking
User=spark
Group=spark
ExecStart=/opt/spark/sbin/start-slave.sh spark://192.168.100.48:7077
ExecStop=/opt/spark/sbin/stop-slave.sh

[Install]
WantedBy=multi-user.target

# Recargar servicios
sudo systemctl daemon-reload
# Iniciar servicio Master
sudo systemctl start spark-master.service
sudo systemctl status spark-master.service
# Abrir puerto para Master
# Obviar si el firewall-cmd esta stop
#sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
#sudo firewall-cmd --reload
# Iniciar servicio Slave
sudo systemctl start spark-slave.service
sudo systemctl status spark-slave.service
#sudo systemctl restart spark-slave.service
###################################################
### Installar Conda
###################################################
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
sudo bash /opt/Miniconda3-py39_4.12.0-Linux-x86_64.sh
# elegir carpeta 
/home/admin/miniconda3
###################################################
### Configurar Conda
###################################################
/home/admin/miniconda3/bin/conda init
exec bash
source .bashrc
conda create --name vuce.sgr.01 python=3.7 -y
###################################################
### Activar Conda env
###################################################
conda activate vuce.sgr.01
###################################################
### Variables PYSPARK - CONDA
###################################################
sudo vi .bashrc
export PYTHONPATH=/home/admin/.conda/envs/vuce.sgr.01/bin/python
export PYSPARK_PYTHON=/home/admin/.conda/envs/vuce.sgr.01/bin/python
export PYSPARK_DRIVER_PYTHON=/home/admin/.conda/envs/vuce.sgr.01/bin/python
source .bashrc
conda activate vuce.sgr.01
###################################################
### Instalar librerias Conda
###################################################
#tensorflow  current version: 2.9.10
conda install -c conda-forge tensorflow -n vuce.sgr.01 -y
#tensorflowonspark version 2.2.5
conda install -c conda-forge tensorflowonspark -n vuce.sgr.01 -y
#spark-tensorflow-distributor -- no existe en conda
#conda install -c conda-forge spark-tensorflow-distributor -n vuce.sgr.01 -y
###################################################
### Prueba de funcionamiento
###################################################
# Archivo
sudo vi /opt/spark/test.file
 line1 word1 word2 word3
line2 word1
line3 word1 word2 word3 word4

# Archivo
/opt/spark/examples/src/main/python/wordcount.py
<<COMMENT
import sys
from operator import add

from pyspark.sql import SparkSession


if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: wordcount <file>", file=sys.stderr)
        sys.exit(-1)

    spark = SparkSession\
        .builder\
        .appName("PythonWordCount")\
        .getOrCreate()

    lines = spark.read.text(sys.argv[1]).rdd.map(lambda r: r[0])
    counts = lines.flatMap(lambda x: x.split(' ')) \
                  .map(lambda x: (x, 1)) \
                  .reduceByKey(add)
    output = counts.collect()
    for (word, count) in output:
        print("%s: %i" % (word, count))

    spark.stop()
COMMENT
# Ejecucion
/opt/spark/bin/spark-submit /opt/spark/examples/src/main/python/wordcount.py /opt/spark/test.file


###################################################
### Fuente
###################################################
https://linuxconfig.org/how-to-install-spark-on-redhat-8
https://github.com/yahoo/TensorFlowOnSpark/wiki/GetStarted_Standalone
https://github.com/yahoo/TensorFlowOnSpark
https://anaconda.org/conda-forge/tensorflowonspark
https://medium.com/@ssatyajitmaitra/you-can-blend-apache-spark-and-tensorflow-to-build-potential-deep-learning-solutions-9298e9fe8f6c



# Nota
# Si el hostname tiene guion abajo _, configurar
# Modificar el hostname, eliminar guion abajo _
hostnamectl status
sudo hostnamectl --static set-hostname atprodext-spark-01
sudo hostnamectl --static set-hostname atprodext-spark-02
sudo hostnamectl --static set-hostname atprodext-spark-03
sudo hostnamectl --static set-hostname atprodext-spark-04

#en cada servidor con su hostname
sudo vi /etc/hosts
<<COMMENT
    127.0.0.1   atprodext-spark-01
COMMENT
sudo reboot 

# Imprimir version lib python
<<COMMENT
>>> import tensorflow as tf
2023-03-06 23:43:08.331851: I tensorflow/core/platform/cpu_feature_guard.cc:193] This TensorFlow binary is optimized with oneAPI Deep Neural Network Library (oneDNN) to use the following CPU instructions in performance-critical operations:  SSE4.1 SSE4.2 AVX AVX2 AVX512F FMA
To enable them in other operations, rebuild TensorFlow with the appropriate compiler flags.

>>> 
>>> import tensorflowonspark as tfos
>>> from tensorflowonspark import TFCluster
>>> tf.__version__
'2.10.0'
>>> tfos.__version__
'2.2.5'
COMMENT