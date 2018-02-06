FROM centos/systemd
MAINTAINER "Aaron D. Schroeder" <aschroed@vt.edu>

ENV container docker

RUN localedef -i en_US -f UTF-8 en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

RUN mkdir /configs
COPY sssd.conf /configs/
COPY journal.conf /configs/
COPY rm_nologin.sh /configs/
COPY userFolders.sh /configs/
COPY groups /configs/

RUN yum update -y && yum upgrade -y
RUN yum install -y sssd && yum install -y authconfig

RUN  yum install -y epel-release; yum clean all

RUN cp /configs/sssd.conf /etc/sssd/
RUN chmod 600 /etc/sssd/sssd.conf

RUN cp /configs/userFolders.sh /usr/bin/
RUN chmod +x /usr/bin/userFolders.sh

RUN mkdir -p /etc/openldap/cacerts
RUN authconfig --nostart --enablesssd --enablesssdauth --enablelocauthorize --update --ldaploadcacert=http://cert.vbi.vt.edu/vbi-cacert.pem
RUN ln -sf /etc/openldap/cacerts/authconfig_downloaded.pem /etc/openldap/cacerts/ef25a808.0
RUN authconfig --enablemkhomedir --update

RUN systemctl enable sssd

VOLUME [ "/sys/fs/cgroup" ]
CMD ["/usr/sbin/init"]
