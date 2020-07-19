[Туториал](https://www.godaddy.com/garage/install-puppet-centos7/) по установке Puppet на CentOs.

Настраиваем /etc/puppet/fileserver.conf:

    [files]
    path /puppet/files
    allow *

Теперь К файлам в **/puppet/files** можно обращаться из манифеста: ```puppet:///files/file.name``` (где **files** - имя модуля [files]).

```/puppet/files``` - симлинк на ~/puppet/files, который обновляется при исполнении Actions.

Не забыть в visudo прописать для пользователя deploy:

    deploy  ALL = NOPASSWD: /bin/puppet

