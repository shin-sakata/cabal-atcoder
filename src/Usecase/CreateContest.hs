module Usecase.CreateContest where

import DomainObject.Contest (Contest, ContestId)
import Usecase.Imports

createContest :: (MonadIO m, MonadThrow m) => ContestId -> m Contest
createContest contestId = undefined