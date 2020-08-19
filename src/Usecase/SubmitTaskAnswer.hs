module Usecase.SubmitTaskAnswer (submitTask) where

import Domain.Object.TaskAnswer (TaskAnswer)
import Usecase.Imports

submitTask :: (MonadIO m, MonadThrow m) => TaskAnswer -> m ()
submitTask task = error "TODO impl"
