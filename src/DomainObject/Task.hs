module DomainObject.Task where

import DomainObject.Task.TaskId (TaskId)
import DomainObject.SourceCode (SourceCode)

data Task = Task
  { id :: TaskId,
    sourceCode :: SourceCode
  }