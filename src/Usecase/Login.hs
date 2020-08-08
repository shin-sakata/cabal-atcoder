module Usecase.Login (login) where

import DomainObject.UserName (UserName (..))
import DomainObject.UserPassword (UserPassword (..))
import InterfaceAdapter.Class.AtCoder (AtCoder (..))
import InterfaceAdapter.Class.SessionManager (SessionManager (..))
import Usecase.Imports

login ::
  ( MonadIO m,
    MonadThrow m,
    SessionManager m,
    AtCoder m
  ) =>
  UserName ->
  UserPassword ->
  m ()
login userName userPassword = do
  session <- createSession userName userPassword
  saveSession session
