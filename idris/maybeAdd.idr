
maybeAdd : Maybe Int -> Maybe Int -> Maybe Int
maybeAdd x y = [ x' + y' | x' <- x, y' <- y ]
