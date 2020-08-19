module Domain.Object.TaskAnswer where

import Domain.Object.TaskId (TaskId)
import Domain.Object.SourceCode (SourceCode)

data TaskAnswer = TaskAnswer
  { id :: TaskId,
    sourceCode :: SourceCode
  }
