{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DerivingStrategies #-}

module DomainObject.TaskId (TaskId (..)) where

import Essential
import GHC.Exts (IsString)

newtype TaskId = TaskId Text
  deriving newtype (Show, Eq, IsString)
