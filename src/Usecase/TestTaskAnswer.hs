module Usecase.TestTaskAnswer where

import Domain.Object.TaskAnswer (TaskAnswer)
import Domain.Object.Status (Status)

testTaskAnswer :: MonadIO m => TaskAnswer -> m Status
testTaskAnswer taskAnswer = undefined