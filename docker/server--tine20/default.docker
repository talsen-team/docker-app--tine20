FROM ubuntu:bionic

ENV DEBIAN_FRONTEND=noninteractive

ENV TINE20_VERSION=2019.08.2

ENV TINE20_PACKAGE_BASEURL=https://packages.tine20.org/source

ENV TINE20_SHA_PACKAGE_FILENAME=sha1sum_${TINE20_VERSION}.txt
ENV TINE20_SHA_PACKAGE_URL=${TINE20_PACKAGE_BASEURL}/${TINE20_VERSION}/${TINE20_SHA_PACKAGE_FILENAME}

ENV TINE20_AIO_PACKAGE_FILENAME=tine20-allinone_${TINE20_VERSION}.tar.bz2
ENV TINE20_AIO_PACKAGE_URL=${TINE20_PACKAGE_BASEURL}/${TINE20_VERSION}/${TINE20_AIO_PACKAGE_FILENAME}

ENV TINE20_HRS_PACKAGE_FILENAME=tine20-humanresources_${TINE20_VERSION}.tar.bz2
ENV TINE20_HRS_PACKAGE_URL=${TINE20_PACKAGE_BASEURL}/${TINE20_VERSION}/${TINE20_HRS_PACKAGE_FILENAME}

ENV TINE20_INV_PACKAGE_FILENAME=tine20-inventory_${TINE20_VERSION}.tar.bz2
ENV TINE20_INV_PACKAGE_URL=${TINE20_PACKAGE_BASEURL}/${TINE20_VERSION}/${TINE20_INV_PACKAGE_FILENAME}

ENV TINE20_PRJ_PACKAGE_FILENAME=tine20-projects_${TINE20_VERSION}.tar.bz2
ENV TINE20_PRJ_PACKAGE_URL=${TINE20_PACKAGE_BASEURL}/${TINE20_VERSION}/${TINE20_PRJ_PACKAGE_FILENAME}

RUN apt-get update                                                                                \
 && apt-get install -y --no-install-recommends                                                    \
                   # tine20 dependencies                                                          \
                   apache2                                                                        \
                   apache2-bin                                                                    \
                   apache2-data                                                                   \
                   apache2-utils                                                                  \
                   fontconfig-config                                                              \
                   fonts-dejavu-core                                                              \
                   libapache2-mod-php7.2                                                          \
                   libapr1                                                                        \
                   libaprutil1                                                                    \
                   libaprutil1-dbd-sqlite3                                                        \
                   libaprutil1-ldap                                                               \
                   libargon2-0                                                                    \
                   libbsd0                                                                        \
                   libbytes-random-secure-perl                                                    \
                   libcrypt-passwdmd5-perl                                                        \
                   libcrypt-random-seed-perl                                                      \
                   libexpat1                                                                      \
                   libfontconfig1                                                                 \
                   libfreetype6                                                                   \
                   libgd3                                                                         \
                   libicu60                                                                       \
                   libjbig0                                                                       \
                   libjpeg-turbo8                                                                 \
                   libjpeg8                                                                       \
                   liblua5.2-0                                                                    \
                   libmagic-mgc                                                                   \
                   libmagic1                                                                      \
                   libmath-random-isaac-perl                                                      \
                   libnghttp2-14                                                                  \
                   libpng16-16                                                                    \
                   libsodium23                                                                    \
                   libtiff5                                                                       \
                   libwebp6                                                                       \
                   libx11-6                                                                       \
                   libx11-data                                                                    \
                   libxau6                                                                        \
                   libxcb1                                                                        \
                   libxdmcp6                                                                      \
                   libxml2                                                                        \
                   libxpm4                                                                        \
                   libxslt1.1                                                                     \
                   libzip4                                                                        \
                   makepasswd                                                                     \
                   mime-support                                                                   \
                   multiarch-support                                                              \
                   mysql-server                                                                   \
                   php-common                                                                     \
                   php7.2-bcmath                                                                  \
                   php7.2-cli                                                                     \
                   php7.2-common                                                                  \
                   php7.2-gd                                                                      \
                   php7.2-intl                                                                    \
                   php7.2-json                                                                    \
                   php7.2-mbstring                                                                \
                   php7.2-mysql                                                                   \
                   php7.2-opcache                                                                 \
                   php7.2-readline                                                                \
                   php7.2-xml                                                                     \
                   php7.2-zip                                                                     \
                   tzdata                                                                         \
                   ucf                                                                            \
                   wwwconfig-common                                                               \
                   # tine20 setup dependencies                                                    \
                   wget                                                                           \
                   sudo                                                                           \
 && mkdir --parents /usr/share/tine20                                                             \
 && cd /tmp                                                                                       \
 && echo "Fetching tine20 archive files ..."                                                      \
 && wget --no-check-certificate ${TINE20_SHA_PACKAGE_URL}                                         \
 && wget --no-check-certificate ${TINE20_AIO_PACKAGE_URL}                                         \
 && wget --no-check-certificate ${TINE20_HRS_PACKAGE_URL}                                         \
 && wget --no-check-certificate ${TINE20_INV_PACKAGE_URL}                                         \
 && wget --no-check-certificate ${TINE20_PRJ_PACKAGE_URL}                                         \
 && echo "Fetching tine20 archive files ... done"                                                 \
 && echo "Verify sha1sums of tine20 archive files ..."                                            \
 && grep --line-number $( sha1sum ${TINE20_AIO_PACKAGE_FILENAME} ) ${TINE20_SHA_PACKAGE_FILENAME} \
 && grep --line-number $( sha1sum ${TINE20_HRS_PACKAGE_FILENAME} ) ${TINE20_SHA_PACKAGE_FILENAME} \
 && grep --line-number $( sha1sum ${TINE20_INV_PACKAGE_FILENAME} ) ${TINE20_SHA_PACKAGE_FILENAME} \
 && grep --line-number $( sha1sum ${TINE20_PRJ_PACKAGE_FILENAME} ) ${TINE20_SHA_PACKAGE_FILENAME} \
 && echo "Verify sha1sums of tine20 archive files ... done"                                       \
 && echo "Extracting tine20 archive files ..."                                                    \
 && tar --extract --bzip2 --file=${TINE20_AIO_PACKAGE_FILENAME} --directory=/usr/share/tine20     \
 && tar --extract --bzip2 --file=${TINE20_HRS_PACKAGE_FILENAME} --directory=/usr/share/tine20     \
 && tar --extract --bzip2 --file=${TINE20_INV_PACKAGE_FILENAME} --directory=/usr/share/tine20     \
 && tar --extract --bzip2 --file=${TINE20_PRJ_PACKAGE_FILENAME} --directory=/usr/share/tine20     \
 && echo "Extracting tine20 archive files ... done"                                               \
 && echo "Removing tin20 leftovers ..."                                                           \
 && rm --force ${TINE20_SHA_PACKAGE_FILENAME}                                                     \
 && rm --force ${TINE20_AIO_PACKAGE_FILENAME}                                                     \
 && rm --force ${TINE20_HRS_PACKAGE_FILENAME}                                                     \
 && rm --force ${TINE20_INV_PACKAGE_FILENAME}                                                     \
 && rm --force ${TINE20_PRJ_PACKAGE_FILENAME}                                                     \
 && rm --force /usr/share/tine20/config.inc.php.dist                                              \
 && echo "Removing tin20 leftovers ... done"                                                      \
 && cd /                                                                                          \
 && echo "Fixing mysql first execution error ..."                                                 \
 && /bin/bash -c 'find /var/lib/mysql/mysql -exec touch -c -a {} + && service mysql start'        \
 && service mysql stop                                                                            \
 && echo "Fixing mysql first execution error ... done"                                            \
 && echo "Storing mysql directory for import if required ..."                                     \
 && mkdir --parents   /import/var/lib                                                             \ 
 && mv /var/lib/mysql /import/var/lib/mysql                                                       \
 && echo "Storing mysql directory for import if required ... done"                                \
 && echo "Creating tine log and lib directories ..."                                              \
 && mkdir --parents                     /var/log/tine20                                           \
 && chown www-data:www-data             /var/log/tine20                                           \
 && chmod --recursive 750               /var/log/tine20                                           \
 && mkdir --parents                     /var/lib/tine20/cache                                     \
 && mkdir --parents                     /var/lib/tine20/files                                     \
 && mkdir --parents                     /var/lib/tine20/sessions                                  \
 && mkdir --parents                     /var/lib/tine20/setup                                     \
 && mkdir --parents                     /var/lib/tine20/tmp                                       \
 && chown --recursive www-data:www-data /var/lib/tine20                                           \
 && chmod --recursive 750               /var/lib/tine20                                           \
 && echo "Creating tine log and lib directories ... done"                                         \
 && echo "Enable apache2 configuration for tine20 ..."                                            \
 && mkdir --parents /var/lib/apache2/conf/enabled_by_admin                                        \
 && touch           /var/lib/apache2/conf/enabled_by_admin/tine20                                 \
 && echo "Enable apache2 configuration for tine20 ... done"                                       \
 && echo "Enable apache modules ..."                                                              \
 && a2enmod expires                                                                               \
 && a2enmod headers                                                                               \
 && a2enmod rewrite                                                                               \
 && echo "Enable apache modules ... done"

COPY "./rootfs/etc/tine20"                       \
      "/import/etc/tine20"
COPY "./rootfs/etc/logrotate.d"                  \
             "/etc/logrotate.d"
COPY "./rootfs/opt/server--tine20/entrypoint.sh" \
             "/opt/server--tine20/entrypoint.sh"
COPY "./rootfs/templates"                        \
             "/templates"

WORKDIR /usr/share/tine20

ENTRYPOINT [ "/bin/bash", "/opt/server--tine20/entrypoint.sh" ]
