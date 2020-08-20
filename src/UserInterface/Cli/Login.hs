module UserInterface.Cli.Login (login) where

import Data.Text.IO as T
import Domain.Object.UserName (UserName (UserName))
import Domain.Object.UserPassword (UserPassword (UserPassword))
import qualified Effect.Adapter.AtCoder as AtCoder
import qualified Effect.Adapter.RIO as RIO
import qualified Effect.Adapter.SessionRepository as Session
import qualified Effect.Handler.AtCoder.Http as HttpAtCoder
import qualified Effect.Handler.SessionRepository.File as FileSession
import Essential
import qualified Usecase.Login as Usecase

login :: RIO env ()
login = do
  userName <- liftIO T.getLine
  userPassword <- liftIO T.getLine
  runLogin (Usecase.login (UserName userName) (UserPassword userPassword))

runLogin :: Eff '[AtCoder.NamedEff, Session.NamedEff, RIO.NamedEff env] a -> RIO env a
runLogin = retractEff . FileSession.run . HttpAtCoder.run mempty
