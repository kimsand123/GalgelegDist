# views.py
import json
import uuid
from collections import namedtuple

from suds.client import Client
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response


@api_view()
def login(request):
    print('1 - Step 1')

    # Remove all methods but POST
    if request.method != "POST":
        json_data = {
            'status': status.HTTP_405_METHOD_NOT_ALLOWED,
            'error': '2 You may only use the auth service with a POST method.',
        }
        return Response(data=json_data, status=status.HTTP_405_METHOD_NOT_ALLOWED)


@api_view(['POST'])
def login(request):
    # Remove all methods but POST
    if request.method != "POST":
        json_data = {
            'status': status.HTTP_405_METHOD_NOT_ALLOWED,
            'error': '1 You may only use the auth service with a POST method.',
        }
        return Response(data=json_data, status=status.HTTP_405_METHOD_NOT_ALLOWED)

    try:
        decoded = request.body.decode('utf-8')
        response = json.loads(decoded)

        # Remove all calls where username and password is not there
        if ('username' not in response) or ('password' not in response):
            json_data = {
                'status': status.HTTP_400_BAD_REQUEST,
                'message': 'You need to send a JSON-body with your request like this: '
                           '{'
                           '\'username\':\'s123456\''
                           '\'password\':\'superPassword\''
                           '}',
            }
            return Response(data=json_data, status=status.HTTP_400_BAD_REQUEST)
    except Exception as e:
        # Remove all calls where username and password is not there
        json_data = {
            'status': status.HTTP_400_BAD_REQUEST,
            'message': 'You need to send a JSON-body with your request like this: '
                       '{'
                       '\'username\':\'s123456\''
                       '\'password\':\'superPassword\''
                       '}',
        }
        return Response(data=json_data, status=status.HTTP_400_BAD_REQUEST)

    # Parse username and password from response
    username = response['username']
    password = response['password']

    url = 'http://javabog.dk:9901/brugeradmin?wsdl'
    client = Client(url)

    # Contact brugeradmin-service, with the username and password
    try:
        client.service.hentBruger(username, password)
        token = uuid.uuid1()
        json_token = {
            'token': token
        }
        return Response(data=json_token, status=status.HTTP_200_OK)
    except Exception as e:
        # If username is in response, there must be a wrong password or username
        if 'Forkert brugernavn eller adgangskode for' in e.__str__():
            json_data = {
                'status': status.HTTP_403_FORBIDDEN,
                'error': 'Wrong password or username',
            }
            return Response(data=json_data, status=status.HTTP_403_FORBIDDEN)
        # Else there must be a server error
        else:
            json_data = {
                'status': status.HTTP_503_SERVICE_UNAVAILABLE,
                'error': 'Something went wrong when we tried to connect to http://javabog.dk:9901/brugeradmin'
            }
            return Response(data=json_data, status=status.HTTP_503_SERVICE_UNAVAILABLE)


# Welcome message for the path "/"
@api_view()
def welcome(request):
    json_data = {
        'status': status.HTTP_200_OK,
        'message': 'This server only contains one Auth service, found at the link below',
        'url': '\'http://' + request.get_host() + '/auth/\''
    }
    return Response(data=json_data, status=status.HTTP_200_OK)


# Bad request message for the all the other paths "/"
@api_view()
def bad_request(request):
    json_data = {
        'status': status.HTTP_400_BAD_REQUEST,
        'message': 'This server only contains one Auth service, found at the link below',
        'url': '\'http://' + request.get_host() + '/auth/\''
    }
    return Response(data=json_data, status=status.HTTP_400_BAD_REQUEST)
