module Usecase.TestTaskAnswer where

import DomainObject.TaskAnswer (TaskAnswer)
import DomainObject.Status (Status)
import Usecase.Imports

testTaskAnswer :: MonadIO m => TaskAnswer -> m Status
testTaskAnswer taskAnswer = undefined