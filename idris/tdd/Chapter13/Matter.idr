module Matter

data Matter = Solid | Liquid | Gas

data MatterCmd : Type -> Matter -> Matter -> Type where
  Melt : MatterCmd () Solid Liquid
  Boil : MatterCmd () Liquid Gas
  Condense : MatterCmd () Gas Liquid
  Freeze : MatterCmd () Liquid Solid

  (>>=) :
    MatterCmd a m1 m2 ->
    (a -> MatterCmd b m2 m3) ->
    MatterCmd b m1 m3

iceSteam : MatterCmd () Solid Gas
iceSteam = do
  Melt
  Boil

steamIce : MatterCmd () Gas Solid
steamIce = do
  Condense
  Freeze

-- Additionally, the following definition should not type-check:
{-
overMelt : MatterCmd () Solid Gas
overMelt = do
  Melt
  Melt
-}
