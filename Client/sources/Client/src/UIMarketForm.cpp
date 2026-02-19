 #include "UIMarketForm.h"
 #include "PacketCmd.h"
 #include "GameApp.h"
void OpenMarketForm() {
    // Requisita itens ao servidor
    CS_MarketList();
    // Exibe a interface do mercado global
    g_pGameApp->ShowForm("frmMarketGlobal");
    MarketUI_Refresh();
}

std::vector<MarketItem> g_marketItems;

void MarketUI_ClearItems() {
    g_marketItems.clear();
}

void MarketUI_AddItem(int market_id, int item_id, int quantidade, int preco, int vendedor_id) {
    MarketItem item = {market_id, item_id, quantidade, preco, vendedor_id};
    g_marketItems.push_back(item);
}

void MarketUI_Refresh() {
    // Atualize a interface visual do mercado global com os itens de g_marketItems
    // Exemplo: atualizar grid, lista, etc.
}

void MarketUI_OnBuyResult(int result, int market_id) {
    // Exemplo: mostrar mensagem de sucesso/erro para compra
    if (result == 1) {
        // Sucesso
        // Exemplo: g_pGameApp->MsgBox("Compra realizada com sucesso!");
    } else {
        // Erro
        // Exemplo: g_pGameApp->MsgBox("Falha ao comprar o item.");
    }
}

void MarketUI_OnAddItemResult(int result, int item_id) {
    if (result == 1) {
        // Sucesso
        // Exemplo: g_pGameApp->MsgBox("Item colocado à venda!");
    } else {
        // Erro
        // Exemplo: g_pGameApp->MsgBox("Falha ao colocar item à venda.");
    }
}

void MarketUI_OnFetchMoneyResult(int result, int valor) {
    if (result == 1) {
        // Sucesso
        // Exemplo: g_pGameApp->MsgBox("Você resgatou ", valor, " moedas!");
    } else {
        // Erro
        // Exemplo: g_pGameApp->MsgBox("Nenhum valor para resgatar.");
    }
}
