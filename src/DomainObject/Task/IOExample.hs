module DomainObject.Task.IOExample where

import Data.Text

data IOExample = IOExample
  { input :: Text,
    output :: Text
  }
