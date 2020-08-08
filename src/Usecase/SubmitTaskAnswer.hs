module Usecase.SubmitTask (submitTask) where

import DomainObject.Status (Status)
import DomainObject.TaskAnswer (TaskAnswer)
import Usecase.Imports

submitTask :: (MonadIO m, MonadThrow m) => TaskAnswer -> m Status
submitTask task = error "TODO impl"
