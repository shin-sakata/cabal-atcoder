module Usecase.SubmitTask (submitTask) where

import DomainObject.Status (Status)
import DomainObject.Task (Task)
import Usecase.Imports

submitTask :: (MonadIO m, MonadThrow m) => Task -> m Status
submitTask task = error "TODO impl"
