module Domain.Object.Task where

import Domain.Object.IOExample (IOExample)
import Domain.Object.SourceCode (SourceCode)
import Domain.Object.TaskId (TaskId)

data Task = Task
  { id :: TaskId,
    ioExample :: IOExample
  }