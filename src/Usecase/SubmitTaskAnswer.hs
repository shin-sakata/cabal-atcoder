module Usecase.SubmitTaskAnswer (submitTask) where

import DomainObject.TaskAnswer (TaskAnswer)
import Essential

submitTask :: (MonadIO m, MonadThrow m) => TaskAnswer -> m ()
submitTask task = error "TODO impl"
