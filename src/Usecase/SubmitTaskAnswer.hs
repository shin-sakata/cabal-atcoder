module Usecase.SubmitTaskAnswer (submitTask) where

import DomainObject.TaskAnswer (TaskAnswer)
import Usecase.Imports

submitTask :: (MonadIO m, MonadThrow m, AtCoder m, SessionManager m) => TaskAnswer -> m ()
submitTask task = error "TODO impl"
