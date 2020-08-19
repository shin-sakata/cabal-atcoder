module Usecase.TestTaskAnswer where

import Domain.Object.TaskAnswer (TaskAnswer)
import Domain.Object.Status (Status)
import Essential

testTaskAnswer :: MonadIO m => TaskAnswer -> m Status
testTaskAnswer taskAnswer = undefined