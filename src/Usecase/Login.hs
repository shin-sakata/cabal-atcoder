module Usecase.Login (login) where

import DomainObject.UserName (UserName (..))
import DomainObject.UserPassword (UserPassword (..))
import Usecase.Imports

login ::
  ( MonadIO m,
    MonadThrow m
  ) =>
  UserName ->
  UserPassword ->
  m ()
login userName userPassword = error "TODO impl"
