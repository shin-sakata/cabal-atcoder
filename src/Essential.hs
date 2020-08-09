module Essential (module Expose, maybeToMonadThrow, eitherToMonadThrow) where

import Control.Arrow
import Control.Exception.Safe as Expose (MonadThrow, throw, throwString)
import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.String.Conversions as Expose (convertString)
import RIO as Expose hiding (throwString)
import RIO.Text as Expose (Text)
import RIO.Orphans as Expose

maybeToMonadThrow :: (MonadThrow m, Exception e) => e -> Maybe a -> m a
maybeToMonadThrow e = throw e `maybe` return

eitherToMonadThrow :: (MonadThrow m, Exception e) => Either e a -> m a
eitherToMonadThrow = throw ||| return
