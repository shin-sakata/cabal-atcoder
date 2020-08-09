module Usecase.Login (login) where

import DomainObject.UserName (UserName)
import DomainObject.UserPassword (UserPassword)
import qualified InterfaceAdapter.Class.AtCoder as AtCoder
import qualified InterfaceAdapter.Class.SessionRepository as SessionRepository
import Usecase.Imports

login ::
  (AtCoder.HasEff effs, SessionRepository.HasEff effs) =>
  UserName ->
  UserPassword ->
  Eff effs ()
login userName userPassword = do
  session <- AtCoder.createSession userName userPassword
  SessionRepository.store session
