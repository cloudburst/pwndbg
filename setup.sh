#!/bin/bash
set -ex

if uname | grep -i Linux &>/dev/null; then
    sudo apt-get update || true
    sudo apt-get -y install gdb python-dev python3-dev python-pip python3-pip libglib2.0-dev libc6-dbg

    if uname -m | grep x86_64 > /dev/null; then
        sudo apt-get install libc6-dbg:i386 || true
    fi
fi

if ! hash gdb; then
    echo 'Could not find gdb in $PATH'
    exit
fi

# Update all submodules
git submodule update --init --recursive

# Find the Python version used by GDB.
PYVER=$(gdb -batch -q --nx -ex 'pi import platform; print(".".join(platform.python_version_tuple()[:2]))')
PYTHON=$(gdb -batch -q --nx -ex 'pi import sys; print(sys.executable)')
PYTHON="${PYTHON}${PYVER}"

# Find the Python site-packages that we need to use so that
# GDB can find the files once we've installed them.
SITE_PACKAGES=$(gdb -batch -q --nx -ex 'pi import site; print(site.getsitepackages()[0])')

# Make sure that pip is available
if ! ${PYTHON} -m pip -V; then
    sudo ${PYTHON} -m ensurepip --upgrade
fi

# Upgrade pip itself
sudo ${PYTHON} -m pip install --upgrade pip

# Install Python dependencies
sudo ${PYTHON} -m pip install --target ${SITE_PACKAGES} -Ur requirements.txt

# Install both Unicorn and Capstone
for directory in capstone unicorn; do
    pushd $directory
    UNICORN_QEMU_FLAGS="--python=$(which python2)" ./make.sh
    sudo UNICORN_QEMU_FLAGS="--python=$(which python2)" ./make.sh install

    cd bindings/python
    sudo ${PYTHON} setup.py install
    popd
done

# Load Pwndbg into GDB on every launch.
if ! grep pwndbg ~/.gdbinit &>/dev/null; then
    echo "source $PWD/gdbinit.py" >> ~/.gdbinit
fi
