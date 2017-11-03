import boto3

event = {
    u'currentIntent': {
        u'slots': {
            u'Device': u'AC',
            u'Attribute': u'temperature',
            u'SetActions': u'set',
            u'Number': u'729',
            u'Room': u'living room'
        },
        u'confirmationStatus': u'None',
        u'name': u'SetAction',
        u'slotDetails': {
            u'Device': {
                u'originalValue': u'ac',
                u'resolutions': [
                    {
                        u'value': u'AC'
                    }
                ]
            },
            u'Attribute': {
                u'originalValue': u'temperature',
                u'resolutions': [
                    {
                        u'value': u'temperature'
                    }
                ]
            },
            u'SetActions': {
                u'originalValue': u'set',
                u'resolutions': [
                    {
                        u'value': u'set'
                    }
                ]
            },
            u'Number': {
                u'originalValue': None,
                u'resolutions': [

                ]
            },
            u'Room': {
                u'originalValue': u'living room',
                u'resolutions': [
                    {
                        u'value': u'living room'
                    },
                    {
                        u'value': u'livingroom'
                    }
                ]
            }
        }
    },
    u'userId': u'ub1dju6r5ogvytd8s4gwcvpigo40apj0',
    u'bot': {
        u'alias': None,
        u'version': u'$LATEST',
        u'name': u'DevicesControl'
    },
    u'inputTranscript': u'set living room ac temperature to seven two nine',
    u'requestAttributes': None,
    u'invocationSource': u'DialogCodeHook',
    u'outputDialogMode': u'Voice',
    u'messageVersion': u'1.0',
    u'sessionAttributes': None
}

context = ''


def build_delegate_response():
    response = {
        "dialogAction": {
            "type": "Delegate",
            event['currentIntent']['slots']
        }
    }
    return response


def build_elicite_slot_response(message, type, intent_name):
    response = {
        "dialogAction": {
            "type": type,  # ElicitSlot, Close
            "message": {
                "contentType": "PlainText",
                "content": message
            },
            "intentName": intent_name,
            event['currentIntent']['slots'],
        "slotToElicit": "slot-name"
    }
    }
    return response


def build_close_response():
    return response


def act():
    return


def handler(event, context):

    if event['invocationSource'] == 'DialogCodeHook':
        if 67 > event['currentIntent']['slots']['Number'] > 82 :
            return build_elicite_slot_response()
        else:
            return build_delegate_response()

    elif event['invocationSource'] == 'FulfillmentCodeHook':
    act()
    return build_response()

handler(event, context)
