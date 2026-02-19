-- Mercado Global Persistente
-- Estrutura e funções principais
print("--------------------------------------------------")
print("[**] Market Global by Guilherme 2026 Files [**]")
-- Tabela principal do mercado global
MARKET_GLOBAL = MARKET_GLOBAL or {}

-- Carregar mercado de arquivo
function LoadMarketGlobal()
    local path = GetResPath("../PlayerData/market_global.lua")
    local f = io.open(path, "r")
    if f then
        local content = f:read("*a")
        f:close()
        if content and #content > 0 then
            local func = loadstring(content)
            if func then
                MARKET_GLOBAL = func() or {}
            end
        end
    end
end

-- Salvar mercado em arquivo
function SaveMarketGlobal()
    local path = GetResPath("../PlayerData/market_global.lua")
    local f = io.open(path, "w+")
    if f then
        f:write("return ", serializeTable(MARKET_GLOBAL))
        f:close()
    end
end

-- Serialização simples de tabela (apenas para persistência)
function serializeTable(val, name, skipnewlines, depth)
    skipnewlines = skipnewlines or false
    depth = depth or 0
    local tmp = string.rep(" ", depth)
    if name then tmp = tmp .. name .. " = " end
    if type(val) == "table" then
        tmp = tmp .. "{"
        if not skipnewlines then tmp = tmp .. "\n" end
        for k, v in pairs(val) do
            local key
            if type(k) == "number" then
                key = "[" .. k .. "]"
            else
                key = k
            end
            tmp = tmp .. serializeTable(v, key, skipnewlines, depth + 2) .. ","
            if not skipnewlines then tmp = tmp .. "\n" end
        end
        tmp = tmp .. string.rep(" ", depth) .. "}"
    else
        if type(val) == "string" then
            tmp = tmp .. string.format("%q", val)
        else
            tmp = tmp .. tostring(val)
        end
    end
    return tmp
end

-- Adicionar item ao mercado
function MarketGlobal_AddItem(player, item)
    local id = #MARKET_GLOBAL + 1
    item.id_mercado = id
    item.status = "ativo"
    item.vendedor = GetChaDefaultName(player)
    MARKET_GLOBAL[id] = item
    SaveMarketGlobal()
    print(string.format("[MARKET] Cadastro: %s cadastrou item %d (id_mercado=%d) por %d moedas, qtd=%d", item.vendedor, item.id_item, id, item.preco, item.quantidade or 1))
    return id
end

-- Remover item do mercado (manual ou após venda)
function MarketGlobal_RemoveItem(id)
    if MARKET_GLOBAL[id] then
        print(string.format("[MARKET] Remoção: %s removeu item %d (id_mercado=%d)", MARKET_GLOBAL[id].vendedor or '?', MARKET_GLOBAL[id].id_item or 0, id))
        MARKET_GLOBAL[id].status = "removido"
        SaveMarketGlobal()
    end
end

-- Comprar item
function MarketGlobal_BuyItem(player, id)
    local item = MARKET_GLOBAL[id]
    if item and item.status == "ativo" then
        local money = GetChaAttr(player, ATTR_GD)
        if money >= item.preco then
            SetChaAttr(player, ATTR_GD, money - item.preco)
            RefreshCha(player)
            -- Armazena o valor para resgate posterior pelo vendedor
            item.status = "vendido"
            item.valor_resgate = (item.valor_resgate or 0) + item.preco
            item.comprador = GetChaDefaultName(player)
            GiveItemX(player, 0, item.id_item, item.quantidade or 1, item.qualidade or 0)
            SaveMarketGlobal()
            print(string.format("[MARKET] Compra: %s comprou item %d (id_mercado=%d) de %s por %d moedas", item.comprador, item.id_item, id, item.vendedor or '?', item.preco))
            return true
        end
    end
    return false
end

-- Função para resgatar dinheiro de vendas
function MarketGlobal_ResgatarVendas(player)
    local nome = GetChaDefaultName(player)
    local total = 0
    for _, item in pairs(MARKET_GLOBAL) do
        if item.vendedor == nome and item.status == "vendido" and item.valor_resgate and item.valor_resgate > 0 then
            total = total + item.valor_resgate
            item.valor_resgate = 0
        end
    end
    if total > 0 then
        local money = GetChaAttr(player, ATTR_GD)
        SetChaAttr(player, ATTR_GD, money + total)
        RefreshCha(player)
        PopupNotice(player, "Você resgatou "..total.." moedas das vendas!")
        SaveMarketGlobal()
        print(string.format("[MARKET] Resgate: %s resgatou %d moedas de vendas.", nome, total))
    else
        PopupNotice(player, "Nenhum valor disponível para resgate.")
    end
end
-- Listar itens ativos
function MarketGlobal_List()
    local list = {}
    for id, item in pairs(MARKET_GLOBAL) do
        if item.status == "ativo" then
            table.insert(list, item)
        end
    end
    return list
end

-- Inicialização
LoadMarketGlobal()