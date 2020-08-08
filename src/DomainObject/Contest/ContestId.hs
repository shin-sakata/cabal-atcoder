{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DerivingStrategies #-}

module DomainObject.Contest.ContestId (ContestId (..)) where

import RIO.Text (Text)
import GHC.Exts (IsString)

newtype ContestId = ContestId Text
  deriving newtype (Show, Eq, IsString)
