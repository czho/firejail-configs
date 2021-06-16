##quiet
# Persistent local customizations
include PROFILE.local
# Persistent global definitions
include globals.local

##ignore noexec ${HOME}
##ignore noexec /tmp

##blacklist PATH
# Disable X11 (CLI only), see also 'x11 none' below
#blacklist /tmp/.X11-unix
# Disable Wayland
#blacklist ${RUNUSER}/wayland-*
# Disable RUNUSER (cli only)
#blacklist ${RUNUSER}

# It is common practice to add files/dirs containing program-specific configuration
# (often ${HOME}/PROGRAMNAME or ${HOME}/.config/PROGRAMNAME) into disable-programs.inc
# (keep list sorted) and then disable blacklisting below.
# One way to retrieve the files a program uses is:
#  - launch binary with --private naming a sandbox
#      `firejail --name=test --ignore=private-bin [--profile=PROFILE] --private BINARY`
#  - work with the program, make some configuration changes and save them, open new documents,
#    install plugins if they exists, etc.
#  - join the sandbox with bash:
#      `firejail --join=test bash`
#  - look what has changed and use that information to populate blacklist and whitelist sections
#      `ls -aR`
#noblacklist PATH

# Allow python (blacklisted by disable-interpreters.inc)
#include allow-python2.inc
#include allow-python3.inc

# Allow perl (blacklisted by disable-interpreters.inc)
#include allow-perl.inc

# Allow java (blacklisted by disable-devel.inc)
include allow-java.inc

# Allow lua (blacklisted by disable-interpreters.inc)
#include allow-lua.inc

# Allow ruby (blacklisted by disable-interpreters.inc)
#include allow-ruby.inc

# Allow gjs (blacklisted by disable-interpreters.inc)
#include allow-gjs.inc

# Allows files commonly used by IDEs
#include allow-common-devel.inc

include disable-common.inc
include disable-devel.inc
#include disable-exec.inc
include disable-interpreters.inc
include disable-passwdmgr.inc
#include disable-programs.inc
#include disable-shell.inc
include disable-write-mnt.inc
include disable-xdg.inc



# This section often mirrors noblacklist section above. The idea is
# that if a user feels too restricted (he's unable to save files into
# home directory for instance) he/she may disable whitelist (nowhitelist)
# in PROFILE.local but still be protected by BLACKLISTS section
# (further explanation at https://github.com/netblue30/firejail/issues/1569)
#mkdir PATH
##mkfile PATH
#whitelist PATH
#include whitelist-common.inc
include whitelist-runuser-common.inc
#include whitelist-usr-share-common.inc
include whitelist-var-common.inc
blacklist ${DESKTOP}
blacklist ${DOWNLOADS}
blacklist ${HOME}/snap

##allusers
#apparmor
#caps.drop all
##caps.keep CAPS

# CLI only
ipc-namespace
# breaks sound and sometime dbus related functions
machine-id
# 'net none' or 'netfilter'
#net none
netfilter
#no3d
##nodbus (deprecated, use 'dbus-user none' and 'dbus-system none', see below)
nodvd
nogroups
nonewprivs
noroot
#nosound
#notv
#nou2f
#novideo
# Remove each unneeded protocol:
#  - unix is usually needed
#  - inet,inet6 only if internet access is required (see 'net none'/'netfilter' above)
#  - netlink is rarely needed
#  - packet almost never
protocol unix,inet,inet6
seccomp
##seccomp !chroot
##seccomp.drop SYSCALLS (see syscalls.txt)
#seccomp.block-secondary
##seccomp-error-action log (Only for debugging seccomp issues)
#shell none
#tracelog
# Prefer 'x11 none' instead of 'blacklist /tmp/.X11-unix' if 'net none' is set
##x11 none

disable-mnt
##private
# It's common practice to refer to the python executable(s) in private-bin with `python*`, which covers both v2 and v3
#private-bin multimc
private-cache
private-dev
#private-etc FILES

##private-lib LIBS
private-opt none
private-tmp


# Since 0.9.63 also a more granular regulation of dbus is supported.
# To get the dbus-addresses to which an application needs access to.
# You can look at flatpak if the application is also distriputed via flatpak:
#    flatpak remote-info --show-metadata flathub <APP-ID>
# Notes:
#  - flatpak implicitly allows an app to own <APP-ID> on the session bus
#  - In order to make dconf work (if it is used by the app) you need to allow
#    'ca.desrt.dconf' even if it is not allowed by flatpak.
# Notes and Policiy about addresses can be found at
# <https://github.com/netblue30/firejail/wiki/Restrict-D-Bus>
dbus-user filter
#dbus-user.own com.github.netblue30.firejail
#dbus-user.talk ca.desrt.dconf
#dbus-user.talk org.freedesktop.Notifications
dbus-system none

##env VAR=VALUE
# memory-deny-write-execute
noexec PATH
##read-only ${HOME}
##join-or-start NAME
