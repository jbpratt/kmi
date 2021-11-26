#!/bin/bash
apt-get update
apt-get autoremove -y
apt-get install ${PKG_LIST}
apt-get autoremove -y
apt-get purge -y