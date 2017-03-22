#!/bin/sh
mkdir -p /tmp/tensorflow_pkg 2>> /dev/null
cd /build/tensorflow-1.0.1 && \
./configure < /tmp/tf-c7.ans && \
bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package && \
bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
# test tf (installation via pip will upgrade CentOS provided numpy,python-setuptools and EPEL python-wheel)
#
# Dependencies Resolved
# 
# ==========================================================================================
#  Package                       Arch             Version          Repository          Size
# ==========================================================================================
# Removing:
#  python-setuptools             noarch           0.9.8-4.el7      @pasteur-base      1.9 M
#  python-wheel                  noarch           0.24.0-2.el7     @epel              251 k
# Removing for dependencies:
#  python-nose                   noarch           1.3.0-3.el7      @pasteur-base      1.1 M
#  python2-pip                   noarch           8.1.2-5.el7      @epel              7.2 M
# 
# Transaction Summary
# ==========================================================================================
# Remove  2 Packages (+2 Dependent packages)

yum -y remove numpy 
pip install numpy
cd / && pip install --user /tmp/tensorflow_pkg/tensorflow-1.0.1-cp27-none-linux_x86_64.whl
python <<EOF
# Creates a graph.
import tensorflow as tf
a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
c = tf.matmul(a, b)
# Creates a session with log_device_placement set to True.
sess = tf.Session(config=tf.ConfigProto(log_device_placement=True))
# Runs the op.
print sess.run(c)
EOF
