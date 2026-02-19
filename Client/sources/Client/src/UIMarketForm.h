#pragma once
#include <vector>

struct MarketItem {
    int market_id;
    int item_id;
    int quantidade;
    int preco;
    int vendedor_id;
};

void MarketUI_ClearItems();
void MarketUI_AddItem(int market_id, int item_id, int quantidade, int preco, int vendedor_id);
void MarketUI_Refresh();
// Feedbacks de operação
void MarketUI_OnBuyResult(int result, int market_id);
void MarketUI_OnAddItemResult(int result, int item_id);
void MarketUI_OnFetchMoneyResult(int result, int valor);
extern std::vector<MarketItem> g_marketItems;

// Função para abrir o mercado global
void OpenMarketForm();
