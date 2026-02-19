@echo off
REM Script para criar links simbólicos ajustados ao diretório do projeto

REM Diretório base do projeto
REM Caminho absoluto do projeto (ajuste se necessário)
set BASEDIR=C:\sources\

REM Função para criar link simbólico após deletar o destino, se existir
setlocal enabledelayedexpansion
for %%A in (
	"C:\server\AccountServer\AccountServer.exe|C:\sources\Server\AccountServer\Bin\AccountServer.exe"
	"C:\server\AccountServer\AccountServer.pdb|C:\sources\Server\AccountServer\Bin\AccountServer.pdb"
	"C:\server\GroupServer\GroupServer.exe|C:\sources\Server\GroupServer\Bin\GroupServer.exe"
	"C:\server\GroupServer\GroupServer.pdb|C:\sources\Server\GroupServer\Bin\GroupServer.pdb"
	"C:\server\GateServer\GateServer.exe|C:\sources\Server\GateServer\Bin\GateServer.exe"
	"C:\server\GateServer\GateServer.pdb|C:\sources\Server\GateServer\Bin\GateServer.pdb"
	"C:\server\GameServer\GameServer.exe|C:\sources\Server\GameServer\Bin\GameServer.exe"
	"C:\server\GameServer\GameServer.pdb|C:\sources\Server\GameServer\Bin\GameServer.pdb"
	"C:\Client\system\Game.exe|C:\sources\Client\bin\system\Game.exe"
	"C:\Client\system\Game.pdb|C:\sources\Client\bin\system\Game.pdb"
	"C:\Client\system\MindPower3D_D8R.dll|C:\sources\Engine\lib\MindPower3D_D8R.dll"
	"C:\Client\system\MindPower3D_D8R.pdb|C:\sources\Engine\lib\MindPower3D_D8R.pdb"
) do (
	for /f "tokens=1,2 delims=|" %%B in ("%%~A") do (
		if exist %%B del /f /q %%B
		mklink %%B %%C
	)
)
endlocal

pause
