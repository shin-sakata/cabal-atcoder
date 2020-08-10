module DomainObject.Contest.ContestId (ContestId (..)) where

import Essential

newtype ContestId = ContestId Text
  deriving newtype (Show, Eq)
