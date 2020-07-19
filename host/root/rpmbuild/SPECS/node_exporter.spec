#https://tresnet.ru/archives/1556

%define debug_package %{nil}

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
