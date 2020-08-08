{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DerivingStrategies #-}

module DomainObject.SourceCode where

import Data.Text
import GHC.Exts (IsString)

newtype SourceCode = SourceCode Text
  deriving newtype (Show, Eq, IsString)
