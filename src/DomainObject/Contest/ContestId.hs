{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DerivingStrategies #-}

module DomainObject.Contest.ContestId (ContestId (..)) where

import GHC.Exts (IsString)
import Essential

newtype ContestId = ContestId Text
  deriving newtype (Show, Eq, IsString)
