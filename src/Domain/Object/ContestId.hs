module Domain.Object.ContestId (ContestId (..)) where

import Essential

newtype ContestId = ContestId Text
  deriving newtype (Eq)

instance Show ContestId where
  show (ContestId contestId) = convertString contestId
