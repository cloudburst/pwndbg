#!/usr/bin/env python
# -*- coding: utf-8 -*-
from __future__ import absolute_import
from __future__ import division
from __future__ import print_function
from __future__ import unicode_literals

import gdb

import pwndbg.symbol


@pwndbg.commands.Command
def l2r(address):
    """Convert GDB local address to IDA remote address"""
    print(hex(pwndbg.ida.l2r(int(address, 16))))
