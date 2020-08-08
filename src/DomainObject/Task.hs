module DomainObject.Task where

import DomainObject.Task.IOExample (IOExample)
import DomainObject.TaskAnswer.SourceCode (SourceCode)
import DomainObject.TaskId (TaskId)

data Task = Task
  { id :: TaskId,
    ioExample :: IOExample
  }