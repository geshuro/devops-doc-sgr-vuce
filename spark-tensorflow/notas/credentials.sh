###################################################
### User VPN client
###################################################
#User: germancayo
#Pass: gc4y0#$
# Credenciales de Componentes de BigData 

### Ambiente de Desarrollo
| Product                            | Hostname                     | IP            | vCPU | Storage | RAM    | User  | Pwd      | S.O.     |
|:-----------------------------------|:-----------------------------|:--------------|:-----|:--------|:-------|:------|:---------|:---------|
| Servidor Apache Flink              | atdesaext-flink              | 192.168.70.14 | 4    | 50 GiB  | 8 GiB  | admin | Adm1n$%& | RHEL 8.5 |
| Servidor Apache Spark/Tensorflow   | atdesaext-spark.vuce.gob.pe  | 192.168.70.15 | 8    | 80 GiB  | 16 GiB | admin | Adm1n$%& | RHEL 8.5 |

### Ambiente de Certificacion
| Product                    | Hostname      | IP               | vCPU | Storage | RAM    | User  | Pwd       | S.O.     |
|:---------------------------|:--------------|:-----------------|:-----|:--------|:-------|:------|:----------|:---------|
| Apache Flink instancia 01  | .vuce.gob.pe  | 192.168.130.143  | 4    | 50 GiB  | 16 GiB | admin | Fn$$w1rt  | RHEL 8.5 |
| Apache Flink instancia 02  | .vuce.gob.pe  | 192.168.130.144  | 4    | 50 GiB  | 8 GiB  | admin | Fn$$w2rt  | RHEL 8.5 |
| Apache Spark/Tensorflow 01 | .vuce.gob.pe  | 192.168.130.145  | 8    | 80 GiB  | 24 GiB | admin | Pk$$w1rt  | RHEL 8.5 |
| Apache Spark/Tensorflow 02 | .vuce.gob.pe  | 192.168.130.146  | 8    | 80 GiB  | 16 GiB | admin | Pk$$w2rt  | RHEL 8.5 |

### Ambiente de Capacitacion
| Product                    | Hostname      | IP               | vCPU | Storage | RAM    | User  | Pwd      | S.O.     |
|:---------------------------|:--------------|:-----------------|:-----|:--------|:-------|:------|:---------|:---------|
| Apache Flink instancia 01  | .vuce.gob.pe  | 192.168.130.148  | 4    | 50 GiB  | 16 GiB | admin | P4$$w0rt | RHEL 8.5 |
| Apache Spark/Tensorflow 01 | .vuce.gob.pe  | 192.168.130.147  | 8    | 80 GiB  | 24 GiB | admin | P3$$w0rt | RHEL 8.5 |

### Ambiente de Produccion
| Product                    | Hostname      | IP              | vCPU | Storage | RAM    | User  | Pwd      | S.O.     |
|:---------------------------|:--------------|:----------------|:-----|:--------|:-------|:------|:---------|:---------|
| Apache Flink instancia 01  | .vuce.gob.pe  | 192.168.100.47  | 4    | 50 GiB  | 16 GiB | admin | Fn$w01rt | RHEL 8.5 |
| Apache Flink instancia 02  | .vuce.gob.pe  | 192.168.100.46  | 4    | 50 GiB  | 8 GiB  | admin | Fn$w02rt | RHEL 8.5 |
| Apache Flink instancia 03  | .vuce.gob.pe  | 192.168.100.49  | 4    | 50 GiB  | 8 GiB  | admin | Fn$w03rt | RHEL 8.5 |
| Apache Flink instancia 04  | .vuce.gob.pe  | 192.168.100.50  | 4    | 50 GiB  | 8 GiB  | admin | Fn$#w2rt | RHEL 8.5 |

| Apache Spark/Tensorflow 01 | .vuce.gob.pe  | 192.168.100.48  | 8    | 80 GiB  | 24 GiB | admin | Pk$w01rt | RHEL 8.5 |
| Apache Spark/Tensorflow 02 | .vuce.gob.pe  | 192.168.100.45  | 8    | 80 GiB  | 16 GiB | admin | Pk$w02rt | RHEL 8.5 |
| Apache Spark/Tensorflow 03 | .vuce.gob.pe  | 192.168.100.51  | 8    | 80 GiB  | 16 GiB | admin | Pk$w03rt | RHEL 8.5 |
| Apache Spark/Tensorflow 04 | .vuce.gob.pe  | 192.168.100.52  | 8    | 80 GiB  | 16 GiB | admin | Pk$w04rt | RHEL 8.5 |

### Puertos
```text
22, 8081, 4040, 18080, 
22, 8080, 6066, 7077, 443, 80, 8888

sudo firewall-cmd --zone=public --add-port=8081/tcp --permanent
sudo firewall-cmd --zone=public --add-port=4040/tcp --permanent
sudo firewall-cmd --zone=public --add-port=18080/tcp --permanent
sudo firewall-cmd --zone=public --add-port=6066/tcp --permanent
sudo firewall-cmd --zone=public --add-port=7077/tcp --permanent
sudo firewall-cmd --zone=public --add-port=443/tcp --permanent
sudo firewall-cmd --zone=public --add-port=80/tcp --permanent
sudo firewall-cmd --zone=public --add-port=8888/tcp --permanent

sudo firewall-cmd --reload
```

### Accesos
| Origen                                   | IP Destino      | Puerto Destino                         |
|:-----------------------------------------|:----------------|:---------------------------------------|
| Usuario VPN                              | ALL IPs         | 22, 8081, 4040, 18080                  |
| ltorres, bsilva, germancayo              |                 |                                        |
| lundero (hvillavicencio,calcantara)      |                 | 22, 7077, 6066, 8080, 8081, 8082, 8888 |
| -                                        |                 |                                        |
| Cluster K8s Certificacion y Capacitacion | 192.168.130.143 | 8081, 4040, 18080                      |
| 10.19.34.157, 10.19.34.158               | 192.168.130.144 | 8081, 4040, 18080                      |
| 10.19.34.159, 10.19.34.160               | 192.168.130.145 | 7077, 6066, 8080                       |
| 10.19.34.163, 10.19.34.209               | 192.168.130.146 | 7077, 6066, 8080                       |
| 10.19.34.246                             | 192.168.130.147 | 8081, 4040, 18080                      |
|                                          | 192.168.130.148 | 7077, 6066, 8080                       |
| -                                        |                 |                                        |
| Cluster K8s Produccion                   | 192.168.100.47  | 8081, 4040, 18080                      |
| 10.19.34.229                             | 192.168.100.46  | 8081, 4040, 18080                      |
| 10.19.34.230                             | 192.168.100.49  | 8081, 4040, 18080                      |
| 10.19.34.234                             | 192.168.100.50  | 8081, 4040, 18080                      |
| 10.19.34.235                             | 192.168.100.48  | 7077, 6066, 8080                       |
| 10.19.34.239                             | 192.168.100.45  | 7077, 6066, 8080                       |
|                                          | 192.168.100.51  | 7077, 6066, 8080                       |
|                                          | 192.168.100.52  | 7077, 6066, 8080                       |

Autores
-------
- Leonardo Torres Ochoa  -  leonardotorres@adiera.com  | https://www.adieraservices.com
