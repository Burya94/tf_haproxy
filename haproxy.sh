#!/bin/bash
yum install haproxy -y
systemctl start haproxy
systemctl enable haproxy
