import base64
from itertools import groupby
from operator import itemgetter
from boto3 import Session

def text_to_mp3(event, context):
    session = Session()
    polly = session.client("polly")

    response = polly.synthesize_speech(Text=event['text'], OutputFormat="mp3", VoiceId=event['voice'])

    encoded = base64.b64encode(response['AudioStream'].read()).decode('utf-8')
    
    return encoded


def describe_voices(event, context):
    
    session = Session()
    polly = session.client("polly")

    response = polly.describe_voices()

    vs = response["Voices"]
    langage_code_getter = itemgetter("LanguageCode")
    sorted_voices       = sorted(vs, key=langage_code_getter)
    grouping_voices     = groupby(vs, key=langage_code_getter)

    res = {}
    for (language_code, voices) in grouping_voices:
        items = []
        for v in voices:
            items.append({"Gender": v["Gender"], "Id": v["Id"]})
            
        res[language_code] = items
    
    return res
