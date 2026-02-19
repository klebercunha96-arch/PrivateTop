--[[
	Lua TradeServer by Billy.
	* Limited quantity by Mothana.
	* Individual item quantity by Angelix.
	* Fixed version for Corsairs files by N1nja

	Todo:
	* LuaAll is not properly working, should update all gameservers.
]]--

print("--------------------------------------------------")
print("[**] Market Global IGS by Guilherme 2026 Files [**]")

-- Comandos Mercado Global
local CMD_CM_MARKET_LIST = 1001
local CMD_CM_MARKET_ADD = 1002
local CMD_CM_MARKET_BUY = 1003
local CMD_CM_MARKET_REMOVE = 1004

-- Registro do handler do Mercado Global
if RegisterPacketHandler then
	RegisterPacketHandler(CMD_CM_MARKET_LIST, MarketGlobal_Operate)
	RegisterPacketHandler(CMD_CM_MARKET_ADD, MarketGlobal_Operate)
	RegisterPacketHandler(CMD_CM_MARKET_BUY, MarketGlobal_Operate)
	RegisterPacketHandler(CMD_CM_MARKET_REMOVE, MarketGlobal_Operate)
else
	print("[Mercado Global] Atenção: RegisterPacketHandler não encontrado. Faça o registro manual conforme o core do seu servidor.")
end

MarketGlobal = {}

function MarketGlobal_Operate(Player, Packet)
	local cmd = ReadCmd(Packet)
	if cmd == CMD_CM_MARKET_LIST then
		local list = MarketGlobal.List()
		local pkt = GetPacket()
		WriteCmd(pkt, CMD_CM_MARKET_LIST)
		MarketGlobal.PacketWriteList(pkt, list)
		SendPacket(Player, pkt)
	elseif cmd == CMD_CM_MARKET_ADD then
		local id_item = ReadDword(Packet)
		local preco = ReadDword(Packet)
		local quantidade = ReadWord(Packet)
		local item = {
			id_item = id_item,
			preco = preco,
			quantidade = quantidade,
			vendedor = GetPlayerName(Player),
		}
		MarketGlobal.AddItem(Player, item)
		PopupNotice(Player, "Item cadastrado no Mercado Global!")
	elseif cmd == CMD_CM_MARKET_BUY then
		local id_mercado = ReadDword(Packet)
		local ok = MarketGlobal.BuyItem(Player, id_mercado)
		if ok then
			PopupNotice(Player, "Compra realizada com sucesso!")
		else
			PopupNotice(Player, "Falha na compra: saldo insuficiente ou item indisponível.")
		end
	elseif cmd == CMD_CM_MARKET_REMOVE then
		local id_mercado = ReadDword(Packet)
		MarketGlobal.RemoveItem(id_mercado)
		PopupNotice(Player, "Item removido do Mercado Global.")
	end
end

function MarketGlobal.PacketWriteItem(pkt, itemId, qty, attrs)
	WriteWord(pkt, itemId)
	WriteWord(pkt, qty or 1)
	WriteWord(pkt, 0)
	for i = 1, 5, 1 do
		if attrs and attrs[i] then
			WriteWord(pkt, attrs[i].ID)
			WriteWord(pkt, attrs[i].Num)
		else
			WriteWord(pkt, 0)
			WriteWord(pkt, 0)
		end
	end
end

function MarketGlobal.PacketWriteList(pkt, items)
	WriteWord(pkt, #items)
	for _, item in ipairs(items) do
		WriteDword(pkt, item.id_mercado or 0)
		WriteDword(pkt, item.id_item)
		WriteString(pkt, item.vendedor or "?")
		WriteDword(pkt, item.preco)
		WriteWord(pkt, item.quantidade or 1)
		-- Adicione outros campos relevantes aqui
	end
end

-- Funções de manipulação de dados (mock/simples, substitua por persistência real)
local market_db = {}
local next_id = 1

function MarketGlobal.List()
	return market_db
end

function MarketGlobal.AddItem(Player, item)
	item.id_mercado = next_id
	next_id = next_id + 1
	table.insert(market_db, item)
end

function MarketGlobal.BuyItem(Player, id_mercado)
	for i, item in ipairs(market_db) do
		if item.id_mercado == id_mercado then
			-- Aqui você pode adicionar lógica de saldo, entrega, etc.
			table.remove(market_db, i)
			return true
		end
	end
	return false
end

function MarketGlobal.RemoveItem(id_mercado)
	for i, item in ipairs(market_db) do
		if item.id_mercado == id_mercado then
			table.remove(market_db, i)
			return true
		end
	end
	return false
end
