module StateMonad

data State : (stateType : Type) -> Type -> Type where
  Get : State stateType stateType
  Put : stateType -> State stateType ()

  Pure : ty -> State stateType ty
  Bind : State stateType a -> (a -> State stateType b) -> State stateType b

runState : State stateType a -> (st : stateType) -> (a, stateType)
runState Get st = (st, st)
runState (Put newState) st = ((), newState)
runState (Pure x) st = (x, st)
runState (Bind action cont) st =
  let (val, nextState) = runState action st
  in runState (cont val) nextState

get : State stateType stateType
get = Get

put : stateType -> State stateType ()
put = Put

mutual
  Functor (State stateType) where
    map f fa = do
      val <- fa
      pure $ f val

  Applicative (State stateType) where
    pure a = Pure a
    f <*> fa = do
      f <- f
      a <- fa
      pure $ f a

  Monad (State stateStyle) where
    (>>=) = Bind

addIfPositive : Integer -> State Integer Bool
addIfPositive val = do
  when (val > 0) $ do
    current <- get
    put (current + val)
  pure $ val > 0

addPositives : List Integer -> State Integer Nat
addPositives vals = do
  added <- traverse addIfPositive vals
  let trues = filter id added
  pure $ length trues
