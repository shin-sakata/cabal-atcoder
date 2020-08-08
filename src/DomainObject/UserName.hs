{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE DerivingStrategies #-}

module DomainObject.UserName where

import Essential
import Data.String (IsString)

newtype UserName = UserName Text
  deriving newtype (Show, Eq, IsString)
