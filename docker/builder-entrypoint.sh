#!/bin/bash

. /opt/rh/gcc-toolset-13/enable

ln -s /opt/rh/gcc-toolset-13/root/usr/bin/aarch64-redhat-linux-gcc /opt/rh/gcc-toolset-13/root/usr/bin/aarch64-linux-gnu-gcc

exec cargo build "$@"
