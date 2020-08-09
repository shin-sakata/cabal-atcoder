module Usecase.Logout (logout) where

import Usecase.Imports
import qualified InterfaceAdapter.Class.SessionRepository as SessionRepository

logout :: SessionRepository.HasEff effs => Eff effs ()
logout = SessionRepository.remove
