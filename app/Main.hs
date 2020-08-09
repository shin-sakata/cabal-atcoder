module Main where

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
import Usecase.Login (login)
import Usecase.Logout (logout)

main :: IO ()
main = do
  userName <- convertString <$> B.getLine
  userPassword <- convertString <$> B.getLine
  runLogin (login (UserName userName) (UserPassword userPassword))

  threadDelay (5 * 1000 * 1000)

  runLogout (logout)

runLogin :: Eff '[AtCoder.NamedEff, Session.NamedEff, IO.NamedEff] a -> IO a
runLogin = retractEff . FileSession.run . HttpAtCoder.run mempty

runLogout :: Eff '[Session.NamedEff, IO.NamedEff] a -> IO a
runLogout = retractEff . FileSession.run
