{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DerivingStrategies #-}

module DomainObject.TaskAnswer.SourceCode where

import GHC.Exts (IsString)
import Essential

newtype SourceCode = SourceCode Text
  deriving newtype (Show, Eq, IsString)
