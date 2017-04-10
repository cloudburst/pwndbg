#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import gdb

import pwndbg.symbol


@pwndbg.commands.Command
def r2l(address):
    """Convert IDA remote address to GDB local address"""
    print(hex(pwndbg.ida.r2l(address)))
