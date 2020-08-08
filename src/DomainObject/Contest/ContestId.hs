{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DerivingStrategies #-}

module DomainObject.Contest.ContestId (ContestId (..)) where

import Data.Text
import GHC.Exts (IsString)

newtype ContestId = ContestId Text
  deriving newtype (Show, Eq, IsString)
