module DomainObject.Task (Task (..), TaskId (..)) where

import Data.Text (Text)
import DomainObject.Task.TaskId (TaskId (..))

data Task = Task
  { id :: TaskId
  }
