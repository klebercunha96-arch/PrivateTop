@echo off
REM Script para compilar projetos principais (Cliente e Servidores)

REM Caminho para o MSBuild (ajuste se necessário)

REM Compilar Cliente
msbuild "c:\sources\Client\proj\kop.sln" /p:Configuration=Release /m

REM Compilar Servidores
msbuild "c:\sources\Server\AccountServer\Proj\AccountServer.sln" /p:Configuration=Release /m
msbuild "c:\sources\Server\GroupServer\Proj\GroupServer.sln" /p:Configuration=Release /m
msbuild "c:\sources\Server\GateServer\Proj\GateServer.sln" /p:Configuration=Release /m
msbuild "c:\sources\Server\GameServer\Proj\GameServer.sln" /p:Configuration=Release /m

pause
