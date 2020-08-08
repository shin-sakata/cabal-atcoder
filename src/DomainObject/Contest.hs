module DomainObject.Contest (Contest (..), ContestId (..)) where

import DomainObject.Contest.ContestId (ContestId (..))
import DomainObject.TaskId (TaskId)
import Essential

data Contest = Contest
  { id :: ContestId,
    tasks :: [TaskId]
  }
