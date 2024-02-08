#!/bin/bash

#Kill apache
pkill -9 apache

#run it in the foreground
/usr/sbin/apache2ctl -D FOREGROUND