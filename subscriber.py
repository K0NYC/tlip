#!/usr/bin/env python3

import paho.mqtt.client as mqtt
import logging

logger =

# This is the Subscriber

def on_connect(client, userdata, flags, rc):
  print("Connected with result code "+str(rc))
  client.subscribe("/livingroom/AC/power")

def on_message(client, userdata, msg):
  if msg.payload.decode() == "on":
    gpoi on
  elif msg.payload.decode() == "off":
      gpio off


client = mqtt.Client()
client.connect("192.168.10.8",1883,60)

client.on_connect = on_connect
client.on_message = on_message

client.loop_forever()
