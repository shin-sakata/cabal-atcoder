module UserInterface.Cli.ClearSession (clearSession) where

import qualified Effect.Adapter.RIO as RIO
import qualified Effect.Adapter.SessionRepository as Session
import qualified Effect.Handler.SessionRepository.File as FileSession
import Essential
import Usecase.Logout (logout)

clearSession :: RIO env ()
clearSession = runLogout logout

runLogout :: Eff '[Session.NamedEff, RIO.NamedEff env] a -> RIO env a
runLogout = retractEff . FileSession.run
