module Usecase.SubmitTaskAnswer (submitTask) where

import Domain.Object.TaskAnswer (TaskAnswer)
import Essential

submitTask :: (MonadIO m, MonadThrow m) => TaskAnswer -> m ()
submitTask task = error "TODO impl"
