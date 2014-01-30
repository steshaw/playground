

MaybeAddT : Type
MaybeAddT = Maybe Int -> Maybe Int -> Maybe Int

maybeAdd : MaybeAddT
maybeAdd x y = [ x' + y' | x' <- x, y' <- y ]

maybeApp : Maybe (a -> b) -> Maybe a -> Maybe b
maybeApp (Just f) (Just a) = Just (f a)
maybeApp _        _        = Nothing

maybeAdd' : MaybeAddT
maybeAdd' x y = (Just (+) `maybeApp` x) `maybeApp` y

maybeAdd'' : MaybeAddT
maybeAdd'' x y = pure (+) <$> x <$> y
