#!/bin/sh

# Populate proxy environment variables from GNOME gsettings.
# This allows to let GNOME manage proxy settings and still being able to pass
# proxy settings to an application launched via .desktop file and using
# environment variables to get the proxy settings.
#
# Note that GNOME terminal automatically define the proxy environment
# variable from gsettings so launching an application from a terminal does not
# require this script.
#
# Note that that "modern" applications get proxy configuration from
# gsettings, so this script is not required.
#
# To be put in /etc/profile.d/gnome_proxy_to_env.sh
#
# Adapted to dash by Julien Guillod from bash script:
# https://gist.github.com/JPvRiel/4e3f6f055b4ac9c31a302450bfdf0758
# https://gist.github.com/egroeper/74b498146bc4dbe26706eec45a509b74


un_single_quote() {
  s="$1"
  s=${s%\'}
  s=${s#\'}
  echo "$s"
}

proxy_on() {
  # http org.gnome.system.proxy.http
  http_host="$(un_single_quote "$(gsettings get org.gnome.system.proxy.http host)")"
  http_port="$(un_single_quote "$(gsettings get org.gnome.system.proxy.http port)")"
  if [ -n "$http_host" ]; then
    export http_proxy="http://$http_host:$http_port"
    export HTTP_PROXY="$http_proxy"
  fi
  # org.gnome.system.proxy.https
  https_host="$(un_single_quote "$(gsettings get org.gnome.system.proxy.https host)")"
  https_port="$(un_single_quote "$(gsettings get org.gnome.system.proxy.https port)")"
  if [ -n "$https_host" ]; then
    export https_proxy="http://$https_host:$https_port"
    export HTTPS_PROXY="$https_proxy"
  fi
  # org.gnome.system.proxy.ftp
  ftp_host="$(un_single_quote "$(gsettings get org.gnome.system.proxy.ftp host)")"
  ftp_port="$(un_single_quote "$(gsettings get org.gnome.system.proxy.ftp port)")"
  if [ -n "$ftp_host" ]; then
    export ftp_proxy="ftp://$ftp_host:$ftp_port"
    export FTP_PROXY="$ftp_proxy"
  fi
  # socks org.gnome.system.proxy.socks
  # TODO: not proccessed for now
  # org.gnome.system.proxy ignore-hosts
  ignore_hosts="$(gsettings get org.gnome.system.proxy ignore-hosts)"
  no_proxy="$(echo "$ignore_hosts" | sed 's/[]['\'' ]//g')"
  if [ -n "$no_proxy" ]; then
    export no_proxy
    export NO_PROXY="$no_proxy"
  fi
}

proxy_off() {
    unset no_proxy
    unset NO_PROXY
    unset http_proxy
    unset HTTP_PROXY
    unset https_proxy
    unset HTTPS_PROXY
    unset ftp_proxy
    unset FTP_PROXY
}

# check for unsupported settings
case "$(un_single_quote "$(gsettings get org.gnome.system.proxy mode)")" in
  manual)
    proxy_on
    ;;
  auto)
    echo "ERROR: Auto, autoconfig-url (PAC) is not yet supported" >&2
    exit 1
    ;;
  none)
    proxy_off
    ;;
  *)
    echo "ERROR: org.gnome.system.proxy mode unknown" >&2
    exit 1
    ;;
esac
if [ "$(gsettings get org.gnome.system.proxy.http use-authentication)" = 'true' ]; then
  echo "ERROR: HTTP proxy authentication is not yet supported" >&2
  exit 1
fi
