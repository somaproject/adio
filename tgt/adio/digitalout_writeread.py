import sys
from somapynet.event import Event
from somapynet import eaddr
from somapynet.neteventio import NetEventIO

import struct
import time

DIGITALOUT_WRITE = 0x30
DIGITALOUT_READ = 0x31



ADDR_DIGITAL_OUT = 0x4A


def digital_out(ip):

    
    addr = ADDR_DIGITAL_OUT
    eio = NetEventIO(ip)
    eio.addRXMask(xrange(256), [addr])
    eio.start()

    vals = True
    
    while True:
        e = Event()
        e.src = eaddr.NETWORK
        e.cmd =  DIGITALOUT_WRITE
        e.data[0] = 0xFFFF
        e.data[1] = 0xFFFF
        if vals:
            e.data[2] = 0xFFFF
            e.data[3] = 0xFFFF
        else:
            e.data[2] = 0x0
            e.data[3] = 0x0

        ea = eaddr.TXDest()
        ea[addr] = 1

        eio.sendEvent(ea, e)


        # now read

        e = Event()
        e.src = eaddr.NETWORK
        e.cmd =  DIGITALOUT_READ

        ea = eaddr.TXDest()
        ea[addr] = 1

        eio.sendEvent(ea, e)

        erx = eio.getEvents(blocking=True)
        for e in erx:
            print e
        vals = not vals
        time.sleep(0.2)
        
    eio.stop()

if __name__ == "__main__":

    somaip = "10.0.0.2"
    digital_out(somaip)
    
