start python AuthServer/manage.py runserver [::]:8970
start java -cp GameServer/GameServer-1.0.jar server.GameServer

timeout 10 /nobreak
start java -cp EntryPointServer/EntryPoint-1.0.jar server.EntryPointServer 1