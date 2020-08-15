module UserInterface.Cli.Login (login) where

import Data.Text.IO as T
import DomainObject.UserName (UserName (UserName))
import DomainObject.UserPassword (UserPassword (UserPassword))
import qualified Effect.Adapter.AtCoder as AtCoder
import qualified Effect.Adapter.IO as IO
import qualified Effect.Adapter.SessionRepository as Session
import qualified Effect.Handler.AtCoder.Http as HttpAtCoder
import qualified Effect.Handler.SessionRepository.File as FileSession
import Essential
import qualified Usecase.Login as Usecase

login :: IO ()
login = do
  userName <- T.getLine
  userPassword <- T.getLine
  runLogin (Usecase.login (UserName userName) (UserPassword userPassword))

runLogin :: Eff '[AtCoder.NamedEff, Session.NamedEff, IO.NamedEff] a -> IO a
runLogin = retractEff . FileSession.run . HttpAtCoder.run mempty
