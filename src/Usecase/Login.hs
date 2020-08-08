module Usecase.Login (login) where

import DomainObject.UserName (UserName (..))
import Usecase.Imports
import DomainObject.UserPassword (UserPassword (..))

login :: (MonadIO m, MonadThrow m) => UserName -> UserPassword -> m ()
login userName userPassword = error "TODO impl"
