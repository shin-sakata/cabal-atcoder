module Domain.Object.SourceCode where

import GHC.Exts (IsString)
import Essential

newtype SourceCode = SourceCode Text
  deriving newtype (Show, Eq, IsString)
