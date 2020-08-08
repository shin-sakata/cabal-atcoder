module Usecase.Login (login) where

import DomainObject.UserName (UserName (..))
import DomainObject.UserPassword (UserPassword (..))
import Control.Monad.IO.Class (MonadIO)
import Control.Exception.Safe (MonadThrow)

login :: (MonadIO m, MonadThrow m) => UserName -> UserPassword -> m ()
login = undefined
