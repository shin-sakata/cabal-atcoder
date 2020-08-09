module Essential (module Expose, maybeToMonadThrow, eitherToMonadThrow) where

import Control.Arrow
import Control.Exception.Safe as Expose
import Control.Monad.IO.Class (MonadIO, liftIO)
import Control.Monad.IO.Class as Expose
import Data.ByteString as Expose (ByteString)
import Data.Proxy as Expose (Proxy (Proxy))
import Data.String.Conversions as Expose (convertString)
import Data.Text as Expose (Text)

maybeToMonadThrow :: (MonadThrow m, Exception e) => e -> Maybe a -> m a
maybeToMonadThrow e = throw e `maybe` return

eitherToMonadThrow :: (MonadThrow m, Exception e) => Either e a -> m a
eitherToMonadThrow = throw ||| return
