module Domain.Object.Contest (Contest (..)) where

import Domain.Object.ContestId (ContestId (..))
import Domain.Object.TaskId (TaskId)
import Essential

data Contest = Contest
  { id :: ContestId,
    tasks :: [TaskId]
  }
