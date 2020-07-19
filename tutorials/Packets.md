# Создание RPM из готового бинаря
Из [инструкции](https://laurvas.ru/prometheus-p1/) по установке мониторинга берем NodeExporter. Нужно создать из него rpm-пакет на основе [бинаря](https://github.com/prometheus/node_exporter/releases). Хотя можно брать и [отсюда](https://packagecloud.io/prometheus-rpm/release/) готовые.

Ставим нужные пакеты:

    yum install -y createrepo yum-utils

Затем либо запускаем ```rpmbuild``` от рута, либо самостоятельно создаём папки в ```/root```:
    
    /root/rpmbuild/*
                   |- SOURCE
                   |- SPECS

В SOURCE должен лежать готовый .tar.gz архив. Для упрощения можно заархивировать следущую структуру папок:

    node_exporter*
                 |- /usr/local/bin/node_exporter
                 |- /etc/systemd/system/node_exporter.service
Тогда при распаковке во время установки файлы попадут куда надо согласно туториалу выше.

Затем пишем ```node_exporter.spec``` в ```SPECS```:

    %define debug_package %{nil}    # решает проблему ERROR: No build ID note found

    Name:       node_exporter
    Version:    1.0.1
    Release:    0
    Summary:    NodeExporter Package

    Group:      System Environment/Base
    License:    GPLv3+
    Source0:    %{name}-%{version}.linux-amd64.tar.gz

    %description
    Testing package.

    %prep
    %setup -q -n %{name}-%{version}.linux-amd64 #unpack tarball

    %build

    %install
    cp -rfa * %{buildroot}


    %files
    /*

Ссылки:
* [статья](#https://tresnet.ru/archives/1556) про готовый конфиг для node_exporter.
* [статья](https://www.thegeekstuff.com/2015/02/rpm-build-package-example/) про создание rpm вообще
* [ответ](https://unix.stackexchange.com/questions/429511/how-to-use-rpmbuild-to-build-a-rpm-package-from-binary-tarball) на форуме по упаковке бинаря в .rpm
* [скрипт](https://gist.github.com/fernandoaleman/1377211/d78d13bd8f134e7d9b9bc3da5895c859d7cbf294) по созданию репы (не использовался)

Запускаем сборку:

    rpmbuild -ba node_exporter.spec

Получаем пакет в ```RPMS/```. Копируем его в папку будущего репозитория, например, в ```/var/www/html/repos/tprepo```.

# Создаем репозиторий
[Digitalocean](https://www.digitalocean.com/community/tutorials/how-to-set-up-and-use-yum-repositories-on-a-centos-6-vps) и [статья](https://phoenixnap.com/kb/create-local-yum-repository-centos).

Создаём репозиторий:

    sudo createrepo /var/www/html/repos
Получаем доп. директорию с данными репы.
Далее создаём файл в ```/etc/yum.repos.d/tp.repo```:

    [tprepo]
    name=Custom Repository
    baseurl=http://rpms.nl-mail.ru
    enabled=1
    gpgcheck=0

Настраиваем nginx. Создаём сервер, обслуживающий поддомен ```rpms``` (см. файл **/etc/nginx/conf.d/rpms.conf**).

Если выдаётся 403 - это мешает SELinux. По умолчанию у Nginx есть доступ только до ```/usr/share/nginx```. Можно отключить, можно договориться по [этой](https://www.nginx.com/blog/using-nginx-plus-with-selinux/) статье (httpd_t - идентификатор Nging-а):

    semanage fcontext -a -t httpd_sys_content_t /var/www/html/...
    restorecon -v /var/www/html/*

Можно запустить

    yum -y update
для обновления репозиториев, а можно и сразу:

    yum install -y node_exporter