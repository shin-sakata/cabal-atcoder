module Usecase.LoginSpec where

import Domain.Object.UserName (UserName (UserName))
import Domain.Object.UserPassword (UserPassword (UserPassword))
import qualified Effect.Adapter.AtCoder as AtCoder
import qualified Effect.Adapter.SessionRepository as Session
import qualified Effect.Handler.AtCoder.Pure as PureAtCoder
import qualified Effect.Handler.SessionRepository.Pure as PureSession
import Essential
import Test.Hspec
import Usecase.Login (login)
import qualified Usecase.Login as Usecase

spec :: Spec
spec = do
  describe "login" do
    it "pure" do
      runLogin (login (UserName "user-name") (UserPassword "user-password")) `shouldBe` ()

runLogin :: Eff '[AtCoder.NamedEff, Session.NamedEff] a -> a
runLogin = leaveEff . PureSession.run . PureAtCoder.run mempty
