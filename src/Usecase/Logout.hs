module Usecase.Logout (logout) where

import Essential
import qualified Effect.Adapter.SessionRepository as SessionRepository

logout :: SessionRepository.HasEff effs => Eff effs ()
logout = SessionRepository.remove
