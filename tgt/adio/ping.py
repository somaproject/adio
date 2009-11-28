"""
Ping the indicated device

"""
import sys
from somapynet.event import Event
from somapynet import eaddr
from somapynet.neteventio import NetEventIO

import struct
import time



PING_REQUEST_CMD = 0x08
PING_RESPONSE_CMD = 0x09
DIGITAL_OUT = 0x4A


def ping_digital_out(ip):


    addr = DIGITAL_OUT
    eio = NetEventIO(ip)
    eio.addRXMask(PING_RESPONSE_CMD, [addr])
    eio.start()

    e = Event()
    e.src = eaddr.NETWORK
    e.cmd =  0x08
    e.data[0] = 0x1234
    e.data[1] = 0x5678

    ea = eaddr.TXDest()
    ea[addr] = 1

    eio.sendEvent(ea, e)

    erx = eio.getEvents(blocking=True)
    for e in erx:
        print e

    eio.stop()

if __name__ == "__main__":

    somaip = "10.0.0.2"
    ping_digital_out(somaip)
    
