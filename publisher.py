#!/usr/bin/env python3

import paho.mqtt.client as mqtt
from w1thermsensor import W1ThermSensor
from  time import sleep

sensor = W1ThermSensor()
temperature_in_fahrenheit = sensor.get_temperature(W1ThermSensor.DEGREES_F)

# This is the Publisher
client = mqtt.Client()
client.connect("192.168.10.8",1883,60)

while True:
    client.publish("/livingroom/AC/temp", temperature_in_fahrenheit);
    sleep(3)


