module Secret

data Access = LoggedOut | LoggedIn
data PasswordCheck = Correct | Incorrect

data ShellCmd : (ty : Type) -> Access -> (ty -> Access) -> Type where
  Password : String -> ShellCmd PasswordCheck LoggedOut
    (\passwordCheck => case passwordCheck of
                            Correct => LoggedIn
                            Incorrect => LoggedOut)

  Logout : ShellCmd () LoggedIn (const LoggedOut)
  GetSecret : ShellCmd String LoggedIn (const LoggedIn)

  PutStr : String -> ShellCmd () state (const state)

  Pure : (res : ty) -> ShellCmd ty (stateFn res) stateFn
  (>>=) :
    ShellCmd a state1 state2Fn ->
    ((res : a) -> ShellCmd b (state2Fn res) state3Fn) ->
    ShellCmd b state1 state3Fn

session : ShellCmd () LoggedOut (const LoggedOut)
session = do
  Correct <- Password "wurzel"
    | Incorrect => PutStr "Incorrect password\n"
  msg <- GetSecret
  PutStr ("Secret code: " ++ show msg ++ "\n")
  Logout

-- Does not type check.
{-
sessionBad : ShellCmd () LoggedOut (const LoggedOut)
sessionBad = do
  Password "wurzel"
  msg <- GetSecret
  PutStr ("Secret code: " ++ show msg ++ "\n")
  Logout
-}

-- Does not type check.
{-
noLogout : ShellCmd () LoggedOut (const LoggedOut)
noLogout = do
  Correct <- Password "wurzel"
    | Incorrect => PutStr "Wrong password"
  msg <- GetSecret
  PutStr ("Secret code: " ++ show msg ++ "\n")
--  Logout
--}
