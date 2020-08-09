module UserInterface.Cli.ClearSession (clearSession) where

import Data.Extensible
import Data.Extensible.Effect
import Essential
import qualified InterfaceAdapter.Class.IO as IO
import qualified InterfaceAdapter.Class.SessionRepository as Session
import qualified InterfaceAdapter.Impl.SessionRepository.File as FileSession
import Usecase.Logout (logout)

clearSession :: RIO SimpleApp ()
clearSession = liftIO $ runLogout logout

runLogout :: Eff '[Session.NamedEff, IO.NamedEff] a -> IO a
runLogout = retractEff . FileSession.run
