module UserInterface.Cli.ClearSession (clearSession) where

import Data.Extensible
import Data.Extensible.Effect
import qualified Effect.Adapter.IO as IO
import qualified Effect.Adapter.SessionRepository as Session
import Essential
import qualified Effect.Handler.SessionRepository.File as FileSession
import Usecase.Logout (logout)

clearSession :: IO ()
clearSession = runLogout logout

runLogout :: Eff '[Session.NamedEff, IO.NamedEff] a -> IO a
runLogout = retractEff . FileSession.run
