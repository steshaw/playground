init : Machine 0 0

insertCoin : Machine pounds (1 + chocs) -> Machine (1 + pounds) (1 + chocs)

vend : Machine (1 + pounds) (1 + chocs) -> Machine pounds chocs

getChange : Machine pounds chocs -> Machine 0 chocs

display : String -> machine pounds chocs -> IO (Machine pounds chocs)

refill : (bars : Nat) -> Machine 0 chocs -> Machine 0 (bars + chocs)
