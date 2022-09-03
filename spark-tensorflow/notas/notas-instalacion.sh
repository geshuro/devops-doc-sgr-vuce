###################################################
### RHEL 8
###################################################
Verificar subcripcion activa
subcription list
###################################################
### Instalar OpenJDK 8
###################################################
sudo dnf install java-11-openjdk-devel
cd /opt
###################################################
### Instalar Apache Spark StandAlone
###################################################
# Descarga de Apache Spark
sudo wget https://dlcdn.apache.org/spark/spark-3.3.0/spark-3.3.0-bin-hadoop3.tgz
# Descomprir en carpeta /opt
sudo tar -xvf spark-3.3.0-bin-hadoop3.tgz
sudo ln -s /opt/spark-3.3.0-bin-hadoop3 /opt/spark
# Crear usuario Spark
useradd spark
# Otorgar permisos Spark a carpeta Spark
sudo chown -R spark:spark /opt/spark*
# Crear servicio Master
sudo vi /etc/systemd/system/spark-master.service
## Archivo Master service
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

# Crear servicio Slave
sudo vi /etc/systemd/system/spark-slave.service
## Archivo Slave service
[Unit]
Description=Apache Spark Slave
After=network.target

[Service]
Type=forking
User=spark
Group=spark
ExecStart=/opt/spark/sbin/start-slave.sh spark://atdesaext-spark.vuce.gob.pe.org:7077
ExecStop=/opt/spark/sbin/stop-slave.sh

[Install]
WantedBy=multi-user.target

# Recargar servicios
sudo systemctl daemon-reload
# Iniciar servicio Master
sudo systemctl start spark-master.service
sudo systemctl status spark-master.service
# Abrir puerto para Master
sudo firewall-cmd --zone=public --add-port=8080/tcp --permanent
sudo firewall-cmd --reload
# Iniciar servicio Slave
sudo systemctl start spark-slave.service

###################################################
### Installar Conda
###################################################
sudo wget https://repo.anaconda.com/miniconda/Miniconda3-py39_4.12.0-Linux-x86_64.sh
sudo bash Miniconda3-py39_4.12.0-Linux-x86_64.sh
###################################################
### Configurar Conda
###################################################
/home/admin/miniconda3/bin/conda init
source .bashrc
conda create --name vuce.sgr.01 python=3.7 -y
###################################################
### Activar Conda env
###################################################
conda activate vuce.sgr.01
###################################################
### Variables PYSPARK - CONDA
###################################################
export PYTHONPATH=/home/admin/miniconda3/envs/vuce.sgr.01/bin/python
export PYSPARK_PYTHON=/home/admin/miniconda3/envs/vuce.sgr.01/bin/python
export PYSPARK_DRIVER_PYTHON=/home/admin/miniconda3/envs/vuce.sgr.01/bin/python
###################################################
### Instalar librerias Conda
###################################################
#tensorflow  current version: 2.9.10
conda install -c conda-forge tensorflow -n vuce.sgr.01 -y
#tensorflowonspark version 2.2.5
conda install -c conda-forge tensorflowonspark -n vuce.sgr.01
#spark-tensorflow-distributor -- no existe en conda
#conda install -c conda-forge spark-tensorflow-distributor -n vuce.sgr.01 -y
###################################################
### Prueba de funcionamiento
###################################################
# Archivo
/opt/spark/examples/src/main/python/wordcount.py

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