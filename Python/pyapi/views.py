# views.py
import json
import uuid

from suds.client import Client
from .serializers import HeroSerializer
from .models import Hero
from rest_framework import status
from rest_framework.decorators import api_view
from rest_framework.response import Response


@api_view(['POST'])
def login(request):
    decoded = request.body.decode('utf-8')
    response = json.loads(decoded)

    username = response['username']
    password = response['password']

    url = 'http://javabog.dk:9901/brugeradmin?wsdl'
    client = Client(url)
    try:
        client.service.hentBruger(username, password)
        token = uuid.uuid1()
        return Response(token, status=status.HTTP_200_OK)
    except Exception as e:
        if 'Forkert brugernavn eller adgangskode for' in e.__str__():
            json_error = {
                'status': status.HTTP_403_FORBIDDEN,
                'error': 'Wrong password or username',
            }
            return Response(data=json_error, status=status.HTTP_403_FORBIDDEN)
        else:
            return Response(status=status.HTTP_500_INTERNAL_SERVER_ERROR)



@api_view(['GET', 'POST'])
def hero_list(request):
    """
    List all code hero, or create a new hero.
    """
    if request.method == 'GET':
        heroes = Hero.objects.all()
        serializer = HeroSerializer(heroes, many=True)
        return Response(data=serializer.data)

    elif request.method == 'POST':
        serializer = HeroSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(data=serializer.data, status=status.HTTP_201_CREATED)
        return Response(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET', 'PUT', 'DELETE'])
def hero_detail(request, name):
    """
    Retrieve, update or delete a hero.
    """
    try:
        hero = Hero.objects.get(name=name)
    except Hero.DoesNotExist:
        return Response(status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = HeroSerializer(hero)
        return Response(data=serializer.data)

    elif request.method == 'PUT':
        serializer = HeroSerializer(hero, data=request.post)
        if serializer.is_valid():
            serializer.save()
            return Response(data=serializer.data)
        return Response(data=serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        hero.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
