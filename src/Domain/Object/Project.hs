module Domain.Object.Project where

import Essential

data Project where
  File :: FileName -> Text -> Project
  Dir :: DirName -> [Project] -> Project

newtype FileName = FileName Text
  deriving (Eq, Show)

type DirName = FileName
