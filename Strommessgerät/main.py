from machine import Pin
from time import sleep_ms
import json

import _thread

try:
    import usocket as socket
except:
    import socket

from machine import Pin
import network

import esp
import gc

def setup_network():
    esp.osdebug(None)
    gc.collect()

    ssid = 'Jugend hackt legacy'

    station = network.WLAN(network.STA_IF)

    station.active(True)
    station.connect(ssid)

    while station.isconnected() == False:
      pass

    print('Connection successful')
    print(station.ifconfig())

setup_network()

s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
s.bind(("", 80))
s.listen(5)

ampere = 0.0
volt = 0.0
watt = 0.0

def server():
    global ampere
    global volt
    global watt

    while True:
        conn, addr = s.accept()
        request = conn.recv(1024)
        request = str(request)

        data = {"ampere": ampere, "volt": volt, "watt": watt}
        response = json.dumps(data)
        conn.send("HTTP/1.1 200 OK\n")
        conn.send("Content-Type: application/json\n")
        conn.send("Connection: close\n\n")
        conn.sendall(response)
        conn.close()


d13 = Pin(13, Pin.IN)  # b
d12 = Pin(12, Pin.IN)  # 3
d14 = Pin(14, Pin.IN)  # 2
d27 = Pin(27, Pin.IN)  # f
d26 = Pin(26, Pin.IN)  # a
d25 = Pin(25, Pin.IN)  # 1
d33 = Pin(33, Pin.IN)  # 4
d32 = Pin(32, Pin.IN)  # g
d35 = Pin(35, Pin.IN)  # c
d34 = Pin(34, Pin.IN)  # p
d39 = Pin(39, Pin.IN)  # d
d36 = Pin(36, Pin.IN)  # e

character_one = "0"
character_two = "0"
character_three = "0"
character_four = "A"

character_inputs = [d25, d13, d35, d39, d36, d27, d32]

def character_values():
    return [character_input.value() for character_input in character_inputs]

def array_to_char(array, original):
    if original in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]:
        if array == [1, 1, 1, 1, 1, 1, 0]:
            return 0
        elif array == [0, 0, 0, 0, 1, 1, 0]:
            return 1
        elif array == [1, 1, 0, 1, 1, 0, 1]:
            return 2
        elif array == [1, 1, 1, 1, 0, 0, 1]:
            return 3
        elif array == [0, 1, 1, 0, 0, 1, 1]:
            return 4
        elif array == [1, 0, 1, 1, 0, 1, 1]:
            return 5
        elif array == [1, 0, 1, 1, 1, 1, 1]:
            return 6
        elif array == [1, 1, 1, 0, 0, 0, 0]:
            return 7
        elif array == [1, 1, 1, 1, 1, 1, 1]:
            return 8
        elif array == [1, 1, 1, 1, 0, 1, 1]:
            return 9
        else:
            return original
    else:
        if array == [1, 1, 1, 0, 1, 1, 1]:
            return "A"
        elif array == [1, 0, 1, 1, 1, 0, 0]:
            return "v"
        else:
            return original

def handle_interrupt(pin):
    global d25, d14, d12, d33
    global character_one, character_two, character_three, character_four
    global ampere, volt, watt

    values = [d25.value(), d14.value(), d12.value(), d33.value()]

    if sum(values) == 3:
        if d25.value() == 0:
            character_one = str(array_to_char(character_values(), character_one))
        elif d14.value() == 0:
            character_two = str(array_to_char(character_values(), character_two))
        elif d12.value() == 0:
            character_three = str(array_to_char(character_values(), character_three))
        elif d33.value() == 0:
            character_four = str(array_to_char(character_values(), character_four))
    elif sum(values) == 0 :
        character_one = "0"
        character_two = "0"
        character_three = "0"
        character_four = "0"
        ampere = 0
        volt = 0

    tempValue = float(character_one + "." + character_two + character_three)

    if character_four == "A":
        ampere = tempValue if tempValue < 2 else ampere
    else:
        volt = tempValue if tempValue < 6 else ampere

    watt = ampere * volt

    sleep_ms(4)

d25.irq(trigger=Pin.IRQ_FALLING, handler=handle_interrupt)
d14.irq(trigger=Pin.IRQ_FALLING, handler=handle_interrupt)
d12.irq(trigger=Pin.IRQ_FALLING, handler=handle_interrupt)
d33.irq(trigger=Pin.IRQ_FALLING, handler=handle_interrupt)

server()
