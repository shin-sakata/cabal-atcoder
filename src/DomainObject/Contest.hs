module DomainObject.Contest (Contest (..), ContestId (..)) where

import Data.Text (Text)
import DomainObject.Task (Task)
import DomainObject.Contest.ContestId (ContestId (..))

data Contest = Contest
  { id :: ContestId,
    tasks :: [Task]
  }