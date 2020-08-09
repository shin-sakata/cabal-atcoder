module Usecase.Logout (logout) where

import Usecase.Imports
import qualified Effect.Adapter.SessionRepository as SessionRepository

logout :: SessionRepository.HasEff effs => Eff effs ()
logout = SessionRepository.remove
