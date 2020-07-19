%define debug_package %{nil}
%define username prometheus
%define usergroup %{username}

Name:       prometheus
Version:    2.19.2
Release:    0
Summary:    Prometheus Package

Group:      System Environment/Base
License:    GPLv3+
Source0:    %{name}-%{version}.linux-amd64.tar.gz

Requires(pre): /usr/sbin/useradd, /usr/bin/getent
Requires(postun): /usr/sbin/userdel

%description
Testing package.

%prep
%setup -q -n %{name}-%{version}.linux-amd64 #unpack tarball

%build

%install	# execute before build
mkdir -p $RPM_BUILD_ROOT/usr/local/bin $RPM_BUILD_ROOT/etc/prometheus $RPM_BUILD_ROOT/etc/systemd/system /var/lib/prometheus
cp -rfa prometheus promtool $RPM_BUILD_ROOT/usr/local/bin
cp prometheus.yml $RPM_BUILD_ROOT/etc/prometheus
cp prometheus.service $RPM_BUILD_ROOT/etc/systemd/system
#cp -rfa * %{buildroot}


%files
/*

%pre
/usr/bin/getent passwd myservice || /usr/sbin/useradd --no-create-home --home-dir / --shell /bin/false %{username}

%post
#execute after installation finished
chown -R %{usergroup}:%{username} /var/lib/prometheus

%preun
#before uninstall

%postun
#after uninstall
/usr/sbin/userdel %{username}