{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DerivingStrategies #-}

module DomainObject.TaskAnswer.SourceCode where

import RIO.Text (Text)
import GHC.Exts (IsString)

newtype SourceCode = SourceCode Text
  deriving newtype (Show, Eq, IsString)
