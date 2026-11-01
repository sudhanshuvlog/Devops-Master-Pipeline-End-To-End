History From Jenkins Worker Node
[root@ip-172-31-0-26 /]# history
    1  cd /
    2  yum install docker -y
    3  systemctl start docker 
    4  docker run -dit --name jenkins -v jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 --restart=on-failure jenkins/jenkins:lts-jdk25
    5  docker ps
    6  docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
    7  wget https://download.oracle.com/java/25/latest/jdk-25_linux-x64_bin.rpm
    8  yum install jdk-25_linux-x64_bin.rpm -y
    9  curl -sO http://52.66.240.42:8080/jnlpJars/agent.jar
   10  ls
   11  java -jar agent.jar -url http://52.66.240.42:8080/ -secret 6216bb71a496bebee10b4c96e8a85ac26cb7b0e509c3cf6114a98409660c6f4d -name ec2 -webSocket -workDir "/data" &
   12  mkdir data
   13  ls
   14  aws configure
   15  clear
   16  yum install git -y
   17  cd data/
   18  ls
   19  cd workspace/end-to-end-gfg-pipeline
   20  cd deploy/playbooks
   21  ls
   22  cat > test.yaml
   23  ansible-playbook test.yaml 
   24  vi test.yaml 
   25  ansible-playbook test.yaml 
   26  cd ..
   27  cd terraformscripts
   28  ls
   29  terraform destroy --auto-approve
   30  cd /
   31  history

History From K8s Master Node

[ec2-user@ip-10-0-1-92 ~]$ sudo su root
c[root@ip-10-0-1-92 ec2-user]# cd /
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]# kubectl get nodes
NAME                                        STATUS   ROLES           AGE     VERSION
ip-10-0-1-125.ap-south-1.compute.internal   Ready    <none>          3m26s   v1.36.6
ip-10-0-1-92                                Ready    control-plane   7m28s   v1.36.6
[root@ip-10-0-1-92 /]# kubectl get pods
No resources found in default namespace.
[root@ip-10-0-1-92 /]# kubectl get ns
NAME              STATUS   AGE
default           Active   7m46s
dev               Active   3m40s
kube-node-lease   Active   7m46s
kube-public       Active   7m46s
kube-system       Active   7m46s
monitoring        Active   2m57s
[root@ip-10-0-1-92 /]# kubectl get pods -n dev
NAME                            READY   STATUS    RESTARTS   AGE
gfgdeployment-b754d645f-2c659   1/1     Running   0          3m47s
gfgdeployment-b754d645f-ggkbc   1/1     Running   0          3m47s
gfgdeployment-b754d645f-smzx4   1/1     Running   0          3m47s
[root@ip-10-0-1-92 /]# kubectl get svc -n dev
NAME           TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
mygfgservice   LoadBalancer   10.102.113.243   <pending>     5000:30096/TCP   4m7s
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]# kubectl get pods -n monitoring
NAME                                                 READY   STATUS      RESTARTS   AGE
fix-permissions-cvhrj                                0/1     Completed   0          4m38s
grafana-7dfcbb7cb5-q4ch8                             1/1     Running     0          4m24s
prometheus-alertmanager-0                            2/2     Running     0          4m30s
prometheus-kube-state-metrics-86f6b846bf-kh6kv       1/1     Running     0          4m31s
prometheus-prometheus-node-exporter-s2fgk            1/1     Running     0          4m31s
prometheus-prometheus-node-exporter-s65n2            1/1     Running     0          4m31s
prometheus-prometheus-pushgateway-5dfd9cc6d4-frv6h   1/1     Running     0          4m31s
prometheus-server-58c9c55cbb-zjrpp                   2/2     Running     0          4m31s
[root@ip-10-0-1-92 /]# kubectl get deployment -n monitoring
NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
grafana                             1/1     1            1           5m5s
prometheus-kube-state-metrics       1/1     1            1           5m12s
prometheus-prometheus-pushgateway   1/1     1            1           5m12s
prometheus-server                   1/1     1            1           5m12s
[root@ip-10-0-1-92 /]# kubectl get pv -n monitoring
NAME             CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                          STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
prometheus-pv    10Gi       RWO            Retain           Bound    monitoring/storage-prometheus-alertmanager-0                  <unset>                          5m28s
prometheus-pv1   10Gi       RWO            Retain           Bound    monitoring/prometheus-server                                  <unset>                          5m28s
[root@ip-10-0-1-92 /]# kubectl get pvc -n monitoring
NAME                                STATUS   VOLUME           CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
prometheus-server                   Bound    prometheus-pv1   10Gi       RWO                           <unset>                 5m41s
storage-prometheus-alertmanager-0   Bound    prometheus-pv    10Gi       RWO                           <unset>                 5m40s
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]# kubectl get svc -n monitoring
NAME                                  TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)          AGE
grafana                               ClusterIP   10.107.245.206   <none>        80/TCP           5m44s
grafana-ext                           NodePort    10.102.206.87    <none>        3000:30306/TCP   5m43s
prometheus-alertmanager               ClusterIP   10.96.105.215    <none>        9093/TCP         5m51s
prometheus-alertmanager-headless      ClusterIP   None             <none>        9093/TCP         5m51s
prometheus-kube-state-metrics         ClusterIP   10.104.191.125   <none>        8080/TCP         5m51s
prometheus-prometheus-node-exporter   ClusterIP   10.99.140.18     <none>        9100/TCP         5m51s
prometheus-prometheus-pushgateway     ClusterIP   10.110.61.202    <none>        9091/TCP         5m51s
prometheus-server                     ClusterIP   10.105.162.236   <none>        80/TCP           5m51s
prometheus-server-ext                 NodePort    10.99.234.123    <none>        9090:32369/TCP   5m49s
[root@ip-10-0-1-92 /]# kubectl get secret -n monitoring
NAME                               TYPE                 DATA   AGE
grafana                            Opaque               3      8m35s
sh.helm.release.v1.grafana.v1      helm.sh/release.v1   1      8m35s
sh.helm.release.v1.prometheus.v1   helm.sh/release.v1   1      8m42s
[root@ip-10-0-1-92 /]# kubectl describe  secret grafana -n monitoring
Name:         grafana
Namespace:    monitoring
Labels:       app.kubernetes.io/component=admin-secret
              app.kubernetes.io/instance=grafana
              app.kubernetes.io/managed-by=Helm
              app.kubernetes.io/name=grafana
              app.kubernetes.io/version=12.3.1
              helm.sh/chart=grafana-10.5.15
Annotations:  meta.helm.sh/release-name: grafana
              meta.helm.sh/release-namespace: monitoring

Type:  Opaque

Data
====
admin-password:  40 bytes
admin-user:      5 bytes
ldap-toml:       0 bytes
[root@ip-10-0-1-92 /]# kubectl get secret grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 --decode echo
base64: echo: No such file or directory
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]# kubectl get secret grafana -n monitoring -o jsonpath='{.data.admin-user}' | base64 --decode
admin[root@ip-10-0-1-92 /]# admin^C
[root@ip-10-0-1-92 /]# kubectl get secret grafana -n monitoring -o jsonpath='{.data.admin-password}' | base64 --decode
M42W6kXPBwSMAdBmBELYcgtifkwlLH32DomzXG2E[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]#
[root@ip-10-0-1-92 /]# kubectl get ns
NAME              STATUS   AGE
default           Active   20m
dev               Active   15m
kube-node-lease   Active   20m
kube-public       Active   20m
kube-system       Active   20m
monitoring        Active   15m
[root@ip-10-0-1-92 /]# kubectl get ns
NAME              STATUS   AGE
default           Active   24m
dev               Active   19m
kube-node-lease   Active   24m
kube-public       Active   24m
kube-system       Active   24m
monitoring        Active   19m
prod              Active   5s
qa                Active   19s
[root@ip-10-0-1-92 /]# kubectl get pods -n qa
NAME                            READY   STATUS    RESTARTS   AGE
gfgdeployment-b754d645f-bwwc9   1/1     Running   0          24s
gfgdeployment-b754d645f-fhmn7   1/1     Running   0          24s
gfgdeployment-b754d645f-zvwjb   1/1     Running   0          24s
[root@ip-10-0-1-92 /]# kubectl get svc -n qa
NAME           TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)          AGE
mygfgservice   LoadBalancer   10.97.17.87   <pending>     5000:30755/TCP   30s
[root@ip-10-0-1-92 /]# kubectl get svc -n prod
NAME           TYPE           CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
mygfgservice   LoadBalancer   10.111.13.197   <pending>     5000:32329/TCP   20s
[root@ip-10-0-1-92 /]# kubectl get pods -n dev
NAME                             READY   STATUS              RESTARTS   AGE
gfgdeployment-58cc4d7b79-2wv28   0/1     ContainerCreating   0          1s
gfgdeployment-58cc4d7b79-m9zz8   1/1     Running             0          8s
gfgdeployment-fcbc48bbb-6jlcx    1/1     Running             0          7m20s
gfgdeployment-fcbc48bbb-wq5kx    1/1     Terminating         0          7m22s
gfgdeployment-fcbc48bbb-xklml    1/1     Running             0          7m17s
[root@ip-10-0-1-92 /]#
