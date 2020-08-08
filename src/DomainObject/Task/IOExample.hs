module DomainObject.Task.IOExample where

import RIO.Text (Text)

data IOExample = IOExample
  { input :: Text,
    output :: Text
  }
