module UserInterface.Cli.Login (login) where

import Data.Extensible
import Data.Extensible.Effect
import DomainObject.UserName (UserName (UserName))
import DomainObject.UserPassword (UserPassword (UserPassword))
import Essential
import qualified InterfaceAdapter.Class.AtCoder as AtCoder
import qualified InterfaceAdapter.Class.IO as IO
import qualified InterfaceAdapter.Class.SessionRepository as Session
import qualified InterfaceAdapter.Impl.AtCoder.Http as HttpAtCoder
import qualified InterfaceAdapter.Impl.SessionRepository.File as FileSession
import qualified RIO.ByteString as B
import qualified Usecase.Login as Usecase

login :: RIO SimpleApp ()
login = do
  userName <- convertString <$> B.getLine
  userPassword <- convertString <$> B.getLine
  runLogin (Usecase.login (UserName userName) (UserPassword userPassword))

runLogin :: Eff '[AtCoder.NamedEff, Session.NamedEff, IO.NamedEff] a -> RIO SimpleApp a
runLogin = liftIO . retractEff . FileSession.run . HttpAtCoder.run mempty
