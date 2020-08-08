module DomainObject.UserPassword where

import RIO.Text (Text)

newtype UserPassword = UserPassword Text
