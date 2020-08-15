module Usecase.Login (login) where

import DomainObject.UserName (UserName)
import DomainObject.UserPassword (UserPassword)
import qualified Effect.Adapter.AtCoder as AtCoder
import qualified Effect.Adapter.SessionRepository as SessionRepository
import Essential

login ::
  (AtCoder.HasEff effs, SessionRepository.HasEff effs) =>
  UserName ->
  UserPassword ->
  Eff effs ()
login userName userPassword = do
  session <- AtCoder.createSession userName userPassword
  SessionRepository.store session
