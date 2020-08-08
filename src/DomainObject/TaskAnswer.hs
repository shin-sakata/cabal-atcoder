module DomainObject.TaskAnswer where

import DomainObject.TaskId (TaskId)
import DomainObject.TaskAnswer.SourceCode (SourceCode)

data TaskAnswer = TaskAnswer
  { id :: TaskId,
    sourceCode :: SourceCode
  }
